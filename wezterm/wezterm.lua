local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.font = wezterm.font('IosevkaTerm NF')
config.adjust_window_size_when_changing_font_size = false
config.font_size = 20
config.allow_square_glyphs_to_overflow_width = 'Always'
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.underline_thickness = 1
config.underline_position = -2
config.line_height = 1

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = 'RESIZE'
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = 'NeverPrompt'
config.native_macos_fullscreen_mode = true
config.mux_enable_ssh_agent = true
-- config.use_dead_keys = false

-- config.color_scheme = 'Kanagawa Dragon (Gogh)'
-- config.color_scheme = 'Frontend Delight (Gogh)'
config.background = {
  {
    source = { File = '/Users/suqoi/Pictures/background/asa.png' },
    opacity = 0.9,
    hsb = { brightness = 0.035, },
  },
}
config.macos_window_background_blur = 20

config.keys = {
  { key = 'v',     mods = 'CMD',            action = wezterm.action.PasteFrom 'Clipboard' },
  { key = 'c',     mods = 'CMD',            action = wezterm.action.CopyTo 'Clipboard' },
  { key = '=',     mods = 'CMD',            action = wezterm.action.IncreaseFontSize },
  { key = '-',     mods = 'CMD',            action = wezterm.action.DecreaseFontSize },
  { key = '0',     mods = 'CMD',            action = wezterm.action.ResetFontSize },
  { key = 'Enter', mods = 'CMD',            action = wezterm.action.ToggleFullScreen },
  { key = 'w',     mods = 'CMD',            action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = '[',     mods = 'CMD|SHIFT|CTRL', action = wezterm.action.ActivateTabRelative(-1) },
  { key = ']',     mods = 'CMD|SHIFT|CTRL', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'r',     mods = 'CMD',            action = wezterm.action.ReloadConfiguration },
  { key = 'Enter', mods = 'SHIFT',          action = wezterm.action { SendString = '\x1b\r' } },
  { key = 'L',     mods = 'CMD|SHIFT|CTRL', action = wezterm.action.ShowDebugOverlay },
  { key = 'P',     mods = 'CMD|SHIFT|CTRL', action = wezterm.action.ActivateCommandPalette },
}


return config
