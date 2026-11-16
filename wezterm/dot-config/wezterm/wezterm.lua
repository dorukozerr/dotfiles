local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- font
config.font = wezterm.font('IosevkaTerm NF')
config.font_size = 24
config.adjust_window_size_when_changing_font_size = false
config.allow_square_glyphs_to_overflow_width = 'Always'
config.harfbuzz_features = { 'calt=1', 'clig=1', 'liga=1' }
config.underline_thickness = 1
config.underline_position = -1

-- config.native_macos_fullscreen_mode = true
config.window_close_confirmation = 'NeverPrompt'
config.hide_tab_bar_if_only_one_tab = true
config.inactive_pane_hsb = { brightness = 0.25 }
config.macos_window_background_blur = 20
config.native_macos_fullscreen_mode = true
config.window_decorations = "TITLE|RESIZE|MACOS_USE_BACKGROUND_COLOR_AS_TITLEBAR_COLOR"

config.color_scheme = 'Black Metal (Venom) (base16)'
config.background = {
  {
    source = { File = '/Users/dumdum/Pictures/backgrounds/01.png' },
    opacity = 0.8,
    hsb = { brightness = 0.01585 },
    horizontal_align = "Center",
    vertical_align = "Middle",
  },
}

config.term = 'wezterm'
config.enable_kitty_keyboard = true
config.enable_kitty_graphics = true
config.front_end = "WebGpu"
config.scrollback_lines = 10000
config.mux_enable_ssh_agent = false
config.default_workspace = 'dumdum'
config.automatically_reload_config = true

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
