-- Window/pane helpers: pane focus, window tiling, font fit on resize, command palette.

local wezterm = require 'wezterm'

local M = {}

-- wezterm.config_dir is empty inside required modules, resolve from this file instead
M.dir = package.searchpath('helpers', package.path):match('^(.*)/')

-- move focus, wrapping to the far side when there is no pane in that direction
function M.focus(dir, opposite)
  return wezterm.action_callback(function(_, pane)
    local tab = pane:tab()
    if tab == nil then
      return
    end
    local target = tab:get_pane_direction(dir)
    if target then
      target:activate()
      return
    end
    local edge = tab:get_pane_direction(opposite)
    while edge do
      edge:activate()
      edge = tab:get_pane_direction(opposite)
    end
  end)
end

-- I mean just wow, with the help of AI, managed to handle resize + grow to
-- fullscreen on macos 27 while forcing square corners with 0 border radius,
-- yias, MACOS 27, ZERO BORDER RADIUS RESIZE
--
-- macOS greys out Window > Move & Resize for title-less windows, so tile from here.
-- scripts/screens.js gives each screen's scale and visible area (no menu bar/dock) in
-- points; wezterm positions in primary-screen pixels and sizes in the target screen's.
local screens_script = M.dir .. '/scripts/screens.js'

-- x, y, w, h as fractions of the visible area
local layouts = {
  left = { 0, 0, 0.5, 1 },
  right = { 0.5, 0, 0.5, 1 },
  top = { 0, 0, 1, 0.5 },
  bottom = { 0, 0.5, 1, 0.5 },
  fill = { 0, 0, 1, 1 },
}

-- the resize lands asynchronously, so poll until the window reports the new size
-- (or give up after ~1s, e.g. when macOS clamps it) before calling done
local function when_sized(window, w, h, done, tries)
  local dims = window:get_dimensions()
  if (dims.pixel_width == w and dims.pixel_height == h) or tries >= 20 then
    return done()
  end
  wezterm.time.call_after(0.05, function()
    when_sized(window, w, h, done, tries + 1)
  end)
end

-- done (optional) runs once the window has its new size, or right away if tiling failed
function M.tile_window(window, layout, done)
  done = done or function() end

  local ok, out = wezterm.run_child_process { 'osascript', '-l', 'JavaScript', screens_script }
  if not ok then
    return done()
  end

  local active = wezterm.gui.screens().active
  local primary_scale, screen
  for line in out:gmatch('[^\n]+') do
    local s = {}
    for n in line:gmatch('%S+') do
      table.insert(s, tonumber(n))
    end
    primary_scale = primary_scale or s[3]
    if math.abs(s[1] * s[3] - active.x) < 2 and math.abs(s[2] * s[3] - active.y) < 2 then
      screen = s
    end
  end
  if not screen then
    return done()
  end

  local _, _, scale, x, y, w, h = table.unpack(screen)
  if layout == 'center' then
    local dims = window:get_dimensions()
    local cw, ch = dims.pixel_width / scale, dims.pixel_height / scale
    x, y, w, h = x + (w - cw) / 2, y + (h - ch) / 2, cw, ch
  else
    local f = layouts[layout]
    x, y, w, h = x + w * f[1], y + h * f[2], w * f[3], h * f[4]
  end

  local pw, ph = math.floor(w * scale), math.floor(h * scale)
  window:set_inner_size(pw, ph)
  window:set_position(math.floor(x * primary_scale), math.floor(y * primary_scale))
  when_sized(window, pw, ph, done, 0)
end

function M.tile(layout)
  return wezterm.action_callback(function(window)
    M.tile_window(window, layout)
  end)
end

-- every new window is filled once. state lives in wezterm.GLOBAL so a config reload
-- doesn't re-tile windows that were moved since. panes that set the wez_wait_tile
-- user var (skhd/fzf/lib.sh) sit on a `read` and get a newline once the fill landed
local function release(id)
  local waiting = wezterm.GLOBAL.tile_waiting or {}
  for _, pane_id in ipairs(waiting[id] or {}) do
    local pane = wezterm.mux.get_pane(pane_id)
    if pane then
      pane:send_text('\n')
    end
  end
  waiting[id] = nil
  wezterm.GLOBAL.tile_waiting = waiting
end

local function fill_new_window(window)
  local id = tostring(window:window_id())
  local tiled = wezterm.GLOBAL.tiled or {}
  if tiled[id] ~= nil then
    return
  end
  tiled[id] = false
  wezterm.GLOBAL.tiled = tiled
  M.tile_window(window, 'fill', function()
    local done = wezterm.GLOBAL.tiled
    done[id] = true
    wezterm.GLOBAL.tiled = done
    release(id)
  end)
end

local function wait_for_tile(window, pane)
  local id = tostring(window:window_id())
  local waiting = wezterm.GLOBAL.tile_waiting or {}
  waiting[id] = waiting[id] or {}
  table.insert(waiting[id], pane:pane_id())
  wezterm.GLOBAL.tile_waiting = waiting
  if (wezterm.GLOBAL.tiled or {})[id] then
    release(id)
  end
end

local function toggle_status_bar(window)
  local overrides = window:get_config_overrides() or {}
  overrides.enable_tab_bar = not window:effective_config().enable_tab_bar
  window:set_config_overrides(overrides)
end

local background_script = M.dir .. '/scripts/background.sh'
local background_default

function M.background(default)
  background_default = default
  local pick = wezterm.GLOBAL.background
  if pick and pick.default == default then
    return pick.file
  end
  return default
end

local function pick_background(config)
  return wezterm.action_callback(function(window, pane)
    local current = config.background[1].source.File
    window:perform_action(wezterm.action.SpawnCommandInNewTab {
      args = { 'bash', background_script, current:match('^(.*)/'), current },
    }, pane)
  end)
end

local function set_background(window, file)
  local pick = wezterm.GLOBAL.background
  if pick and pick.file == file then
    return
  end
  wezterm.GLOBAL.background = { default = background_default, file = file }
  -- drop the background override the old picker left behind
  local overrides = window:get_config_overrides() or {}
  if overrides.background then
    overrides.background = nil
    window:set_config_overrides(overrides)
  end
  wezterm.reload_configuration()
end

function M.apply_to_config(config)
  -- wezterm.on("window-resized", function(window, _)
  --   local w_d = window:get_dimensions()
  --   local w_s = window:active_tab():get_size()
  --   local w_key = string.format("%d:%dx%d", window:window_id(), w_d.pixel_width, w_d.pixel_height)

  --   if wezterm.GLOBAL.fit_key == w_key then return end
  --   wezterm.GLOBAL.fit_key = w_key

  --   local overrides = window:get_config_overrides() or {}
  --   local cell_h, rows = w_s.pixel_height / w_s.rows, w_s.rows
  --   local current = overrides.font_size or config.font_size
  --   local target = w_d.pixel_height / (rows * cell_h)

  --   overrides.font_size = current * target * 0.995
  --   overrides.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

  --   wezterm.GLOBAL.pad_pending = w_key

  --   window:set_config_overrides(overrides)
  -- end)

  -- wezterm.on("window-config-reloaded", function(window, _)
  --   local w_d = window:get_dimensions()
  --   local w_s = window:active_tab():get_size()
  --   local w_key = string.format("%d:%dx%d", window:window_id(), w_d.pixel_width, w_d.pixel_height)

  --   if wezterm.GLOBAL.pad_pending ~= w_key then return end
  --   wezterm.GLOBAL.pad_pending = nil

  --   local overrides = window:get_config_overrides() or {}

  --   local top = math.floor(w_d.pixel_height % (w_s.pixel_height / w_s.rows))

  --   overrides.window_padding = { left = 0, right = 0, top = top, bottom = 0 }

  --   window:set_config_overrides(overrides)
  -- end)

  wezterm.on('augment-command-palette', function()
    return {
      { brief = 'Toggle status bar', action = wezterm.action_callback(toggle_status_bar) },
      { brief = 'Select background', action = pick_background(config) },
    }
  end)

  wezterm.on('user-var-changed', function(window, pane, name, value)
    if name == 'wez_bg' and value ~= '' then
      set_background(window, value)
    elseif name == 'wez_wait_tile' then
      wait_for_tile(window, pane)
    end
  end)

  -- fires right after a window is created (then every status_update_interval)
  wezterm.on('update-status', function(window)
    fill_new_window(window)
  end)
end

return M
