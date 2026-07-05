local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.font = wezterm.font("IosevkaTerm NF")
-- config.font = wezterm.font("CaskaydiaCove Nerd Font")
config.font_size = 20
config.allow_square_glyphs_to_overflow_width = "Always"
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
config.underline_thickness = 1
config.underline_position = -2

config.window_padding = { left = 8, right = 8, top = 10, bottom = 5 }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.native_macos_fullscreen_mode = true
config.window_background_opacity = 1
config.macos_window_background_blur = 0

-- config.color_scheme = 'Black Metal (Venom) (base16)'
-- config.color_scheme = 'Ashes (dark) (terminal.sexy)'
-- config.color_scheme = 'Solarized Light (Gogh)'
config.color_scheme = 'Solarized Dark (Gogh)'
config.window_background_opacity = 0.925
config.macos_window_background_blur = 10

--
config.keys = {
  { key = "v",     mods = "CMD",       action = wezterm.action.PasteFrom "Clipboard" },
  { key = "c",     mods = "CMD",       action = wezterm.action.CopyTo "Clipboard" },
  { key = "=",     mods = "CMD",       action = wezterm.action.IncreaseFontSize },
  { key = "-",     mods = "CMD",       action = wezterm.action.DecreaseFontSize },
  { key = "0",     mods = "CMD",       action = wezterm.action.ResetFontSize },
  { key = "n",     mods = "CMD",       action = wezterm.action.SpawnTab "CurrentPaneDomain" },
  { key = "Enter", mods = "CMD",       action = wezterm.action.ToggleFullScreen },
  { key = "w",     mods = "CMD",       action = wezterm.action.CloseCurrentTab { confirm = false } },
  { key = "n",     mods = "CMD|SHIFT", action = wezterm.action.SpawnWindow },
  { key = "[",     mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(-1) },
  { key = "]",     mods = "CMD|SHIFT", action = wezterm.action.ActivateTabRelative(1) },
  { key = "r",     mods = "CMD",       action = wezterm.action.ReloadConfiguration },
  { key = "Enter", mods = "SHIFT",     action = wezterm.action { SendString = "\x1b\r" } },
  { key = "L",     mods = "CMD|SHIFT", action = wezterm.action.ShowDebugOverlay },
}

return config
