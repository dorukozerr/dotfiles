-- Status bar: tabline.wez (local submodule in plugins/) with airline-style blocks.
--
--   workspace | tab:pane   tabs ...                   ↓ net ↑ | tmux Ns Nw Np

local wezterm = require 'wezterm'

local M = {}

local dir = require('helpers').dir

-- tabline's init.lua locates itself via wezterm.plugin.list(), which only knows
-- plugins fetched by wezterm.plugin.require, so load its modules straight from disk
package.path = dir .. '/plugins/tabline.wez/plugin/?.lua;' .. package.path

-- airline section tokens read from tmux's snapshot.conf (written by t_ap), so both
-- bars follow one theme. `%hidden NAME="value"` lines, values may reference
-- earlier tokens as ${NAME}. the file is watched, regenerating it reloads wezterm
local snapshot = wezterm.home_dir .. '/.config/tmux/snapshot.conf'

local function read_tokens(path)
  local tokens = {}
  local f = io.open(path)
  if not f then
    return tokens
  end
  for line in f:lines() do
    local name, value = line:match('^%%hidden%s+([%w_]+)="([^"]*)"')
    if name then
      tokens[name] = (value:gsub('%${([%w_]+)}', tokens))
    end
  end
  f:close()
  return tokens
end

-- tokens may be tmux colour names (t_ap -a): black..white, brightblack..brightwhite,
-- colourN and default. resolve those through the wezterm color scheme's palette so
-- both bars follow the terminal theme, default becomes transparent like in tmux
local ansi_names = { 'black', 'red', 'green', 'yellow', 'blue', 'magenta', 'cyan', 'white' }

local function palette(scheme_name)
  local scheme = scheme_name and wezterm.color.get_builtin_schemes()[scheme_name] or {}
  local p = {}
  for i, name in ipairs(ansi_names) do
    p[name] = scheme.ansi and scheme.ansi[i]
    p['bright' .. name] = scheme.brights and scheme.brights[i]
  end
  return p
end

local function resolve(value, p)
  if value == 'default' then
    return 'rgba(0,0,0,0)'
  end
  local n = tonumber(value:match('^colou?r(%d+)$'))
  if n and n < 8 then
    value = ansi_names[n + 1]
  elseif n and n < 16 then
    value = 'bright' .. ansi_names[n - 7]
  end
  return p[value] or value
end

-- set by apply_to_config, which knows the color scheme
local A_FG, A_BG, B_FG, B_BG, C_FG, C_BG

-- fallbacks are base16_black_metal_venom, in case the file is missing
local function load_colors(scheme_name)
  local t, p = read_tokens(snapshot), palette(scheme_name)
  A_FG, A_BG = resolve(t.A_FG or '#121212', p), resolve(t.A_BG or '#999999', p)
  B_FG, B_BG = resolve(t.B_FG or '#999999', p), resolve(t.B_BG or '#222222', p)
  C_FG, C_BG = resolve(t.C_FG or '#c1c1c1', p), resolve(t.C_BG or '#121212', p)
end

-- airline slants like tmux/vim, but as separate blocks floating on the bar
local block_l = '\u{e0be}'
local block_r = '\u{e0b8}'

-- format items embedded in a Text component, tabline renders the escapes.
-- edge = 'left'/'right' drops that cap so the block runs flush to the window edge
local function block(text, fg, bg, edge)
  local items = {}
  if edge ~= 'left' then
    table.insert(items, { Background = { Color = C_BG } })
    table.insert(items, { Foreground = { Color = bg } })
    table.insert(items, { Text = block_l })
  end
  table.insert(items, { Background = { Color = bg } })
  table.insert(items, { Foreground = { Color = fg } })
  table.insert(items, { Attribute = { Intensity = 'Bold' } })
  table.insert(items, { Text = ' ' .. text .. ' ' })
  table.insert(items, { Attribute = { Intensity = 'Normal' } })
  if edge ~= 'right' then
    table.insert(items, { Background = { Color = C_BG } })
    table.insert(items, { Foreground = { Color = bg } })
    table.insert(items, { Text = block_r })
  end
  return wezterm.format(items)
end

local function workspace_block(window)
  return block(window:active_workspace(), A_FG, A_BG, 'left')
end

-- tmux #I:#P
local function tab_pane_block(window)
  local tab_index, pane_index = 0, 0
  for _, t in ipairs(window:mux_window():tabs_with_info()) do
    if t.is_active then tab_index = t.index end
  end
  for _, p in ipairs(window:active_tab():panes_with_info()) do
    if p.is_active then pane_index = p.index end
  end
  return block(tab_index .. ':' .. pane_index, B_FG, B_BG)
end

-- system stats from scripts/status.sh, run at most every 2s and shared by all windows
local status_script = dir .. '/scripts/status.sh'

local stats = { tmux = nil, down = 0, up = 0 }
local last = { at = 0, rx = nil, tx = nil }

local function now()
  return tonumber(wezterm.time.now():format('%s%.3f')) or os.time()
end

local function refresh_stats()
  local t = now()
  if t - last.at < 2 then
    return
  end
  local ok, out = wezterm.run_child_process { 'sh', status_script }
  if not ok then
    return
  end

  stats.tmux = nil
  for line in out:gmatch('[^\n]+') do
    local kind, rest = line:match('^(%S+) (.*)$')
    if kind == 'tmux' then
      local s, w, p = rest:match('(%d+) (%d+) (%d+)')
      if tonumber(s) > 0 then
        stats.tmux = s .. 's ' .. w .. 'w ' .. p .. 'p'
      end
    elseif kind == 'net' then
      local rx, tx = rest:match('(%d+) (%d+)')
      rx, tx = tonumber(rx), tonumber(tx)
      if last.rx then
        local dt = t - last.at
        stats.down = math.max(rx - last.rx, 0) / dt
        stats.up = math.max(tx - last.tx, 0) / dt
      end
      last.rx, last.tx = rx, tx
    end
  end
  last.at = t
end

-- fixed width so the bar doesn't jitter as numbers change
local function rate(bytes)
  local units = { 'B', 'K', 'M', 'G' }
  local i = 1
  while bytes >= 1000 and i < #units do
    bytes = bytes / 1024
    i = i + 1
  end
  local fmt = bytes >= 10 and '%4.0f' or '%4.1f'
  return string.format(fmt, bytes) .. units[i] .. '/s'
end

local function net_block()
  refresh_stats()
  return block('↓' .. rate(stats.down) .. ' ↑' .. rate(stats.up), B_FG, B_BG)
end

local function tmux_block()
  refresh_stats()
  return block('tmux ' .. (stats.tmux or 'off'), A_FG, A_BG, 'right')
end

local function tabline_opts()
  -- tabline colors its sections per key table, keep the bar fill the same in all of them
  local fill = { c = { fg = C_FG, bg = C_BG } }

  return {
    options = {
      icons_enabled = false,
      tabs_enabled = true,
      theme_overrides = {
        normal_mode = fill,
        copy_mode = fill,
        search_mode = fill,
        tab = {
          active = { fg = B_FG, bg = B_BG },
          inactive = { fg = C_FG, bg = C_BG },
          inactive_hover = { fg = B_FG, bg = C_BG },
        },
      },
      section_separators = '',
      component_separators = '',
      tab_separators = { left = block_r, right = block_l },
    },
    sections = {
      tabline_a = {},
      tabline_b = {},
      tabline_c = { workspace_block, tab_pane_block },
      tab_active = { { Attribute = { Intensity = 'Bold' } }, 'process' },
      tab_inactive = { 'process' },
      tabline_x = { net_block, tmux_block },
      tabline_y = {},
      tabline_z = {},
    },
    extensions = {},
  }
end

-- call after config.color_scheme is set, tmux colour names resolve through it
function M.apply_to_config(config)
  -- what tabline's own setup() does, minus the plugin path lookup
  wezterm.add_to_config_reload_watch_list(snapshot)

  load_colors(config.color_scheme)
  require('tabline.config').set(tabline_opts())
  wezterm.on('update-status', function(window, pane)
    require('tabline.component').set_status(window, pane)
  end)
  wezterm.on('format-tab-title', function(tab, _, _, _, hover, _)
    return require('tabline.tabs').set_title(tab, tab.active_pane, hover)
  end)

  config.use_fancy_tab_bar = false
  config.tab_bar_at_bottom = false
  config.show_new_tab_button_in_tab_bar = false
  config.tab_max_width = 32
  config.status_update_interval = 500
  config.colors = config.colors or {}
  config.colors.tab_bar = { background = C_BG }
  config.colors.split = B_BG
  config.colors.selection_fg = B_FG
  config.colors.selection_bg = B_BG
end

return M
