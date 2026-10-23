local wezterm = require 'wezterm'
local helpers = require('helpers')
local statusbar = require('statusbar')

local config = wezterm.config_builder()
local act = wezterm.action
local home = wezterm.home_dir

helpers.apply_to_config(config)

-- font
config.font = wezterm.font('IosevkaTerm NF')
config.font_size = 28
config.adjust_window_size_when_changing_font_size = false
config.allow_square_glyphs_to_overflow_width = 'Always'
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.underline_thickness = 1
config.underline_position = -1

-- window
config.window_decorations = 'RESIZE|MACOS_FORCE_SQUARE_CORNERS'
-- native fullscreen needs a titled window, RESIZE-only windows can't enter it
config.native_macos_fullscreen_mode = true
config.window_close_confirmation = 'NeverPrompt'
config.hide_tab_bar_if_only_one_tab = true
config.inactive_pane_hsb = { brightness = 0.25 }
config.color_scheme = 'Black Metal (Venom) (base16)'
config.background = {
  {
    source = { File = helpers.background('/Users/dumdum/Pictures/backgrounds/01.png') },
    opacity = 1,
    hsb = { brightness = 0.0125 },
    horizontal_align = "Center",
    vertical_align = "Middle",
  },
}
-- config.macos_window_background_blur = 20
-- after color_scheme, the bar resolves tmux colour names through its palette
statusbar.apply_to_config(config)

-- terminal
config.term = 'wezterm'
-- config.enable_kitty_keyboard = true
config.enable_kitty_graphics = true
config.front_end = "WebGpu"
config.scrollback_lines = 5000
config.mux_enable_ssh_agent = false
config.default_workspace = 'dumdum'
config.automatically_reload_config = true

config.keys = {
  -- window tiling, stand-in for macOS Move & Resize
  { key = 'LeftArrow',  mods = 'CTRL|ALT',       action = helpers.tile('left') },
  { key = 'RightArrow', mods = 'CTRL|ALT',       action = helpers.tile('right') },
  { key = 'UpArrow',    mods = 'CTRL|ALT',       action = helpers.tile('top') },
  { key = 'DownArrow',  mods = 'CTRL|ALT',       action = helpers.tile('bottom') },
  { key = 'f',          mods = 'CTRL|ALT',       action = helpers.tile('fill') },
  { key = 'c',          mods = 'CTRL|ALT',       action = helpers.tile('center') },

  -- tmux mappings, M-S-key there, CMD-S-C-key here
  -- I believe I can fly I believe I can touch the sky I think about it every
  -- night and day Spread my wings and fly away
  { key = 'H',          mods = 'CMD|SHIFT|CTRL', action = helpers.focus('Left', 'Right') },
  { key = 'J',          mods = 'CMD|SHIFT|CTRL', action = helpers.focus('Down', 'Up') },
  { key = 'K',          mods = 'CMD|SHIFT|CTRL', action = helpers.focus('Up', 'Down') },
  { key = 'L',          mods = 'CMD|SHIFT|CTRL', action = helpers.focus('Right', 'Left') },
  { key = 'LeftArrow',  mods = 'CMD|SHIFT|CTRL', action = act.AdjustPaneSize { 'Left', 5 } },
  { key = 'RightArrow', mods = 'CMD|SHIFT|CTRL', action = act.AdjustPaneSize { 'Right', 5 } },
  { key = 'UpArrow',    mods = 'CMD|SHIFT|CTRL', action = act.AdjustPaneSize { 'Up', 5 } },
  { key = 'DownArrow',  mods = 'CMD|SHIFT|CTRL', action = act.AdjustPaneSize { 'Down', 5 } },
  { key = '{',          mods = 'CMD|SHIFT|CTRL', action = act.SwitchWorkspaceRelative(-1) },
  { key = '}',          mods = 'CMD|SHIFT|CTRL', action = act.SwitchWorkspaceRelative(1) },
  { key = 'Q',          mods = 'CMD|SHIFT|CTRL', action = act.CloseCurrentPane { confirm = false } },
  { key = 'W',          mods = 'CMD|SHIFT|CTRL', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES|TABS' } },
  { key = 'Z',          mods = 'CMD|SHIFT|CTRL', action = act.TogglePaneZoomState },
  { key = 'N',          mods = 'CMD|SHIFT|CTRL', action = act.ActivateTabRelative(1) },
  { key = 'P',          mods = 'CMD|SHIFT|CTRL', action = act.ActivateTabRelative(-1) },
  { key = '|',          mods = 'CMD|SHIFT|CTRL', action = act.ActivateCopyMode },
  { key = '%',          mods = 'CMD|SHIFT|CTRL', action = act.SplitHorizontal { domain = 'CurrentPaneDomain', cwd = home } },
  { key = '"',          mods = 'CMD|SHIFT|CTRL', action = act.SplitVertical { domain = 'CurrentPaneDomain', cwd = home } },
  { key = 'C',          mods = 'CMD|SHIFT|CTRL', action = act.SpawnCommandInNewTab { domain = 'CurrentPaneDomain', cwd = home } },
  { key = '?',          mods = 'CMD|SHIFT|CTRL', action = act.ShowDebugOverlay },
  { key = ':',          mods = 'CMD|SHIFT|CTRL', action = act.ActivateCommandPalette },
  {
    key = '$',
    mods = 'CMD|SHIFT|CTRL',
    action = act.PromptInputLine {
      description = 'Rename workspace',
      action = wezterm.action_callback(function(window, _, line)
        if line and line ~= '' then
          wezterm.mux.rename_workspace(window:active_workspace(), line)
        end
      end),
    },
  },

  -- cmd+c/v, cmd+=/-/0 and cmd+r are wezterm defaults
  -- { key = 'Enter',      mods = 'CMD',            action = act.ToggleFullScreen },
  { key = 'Enter', mods = 'SHIFT', action = act.SendString '\x1b\r' },
}

return config
