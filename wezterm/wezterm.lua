local wezterm = require "wezterm"
local config = wezterm.config_builder()

config.font = wezterm.font("IosevkaTerm NF")
config.adjust_window_size_when_changing_font_size = false
config.font_size = 20
config.allow_square_glyphs_to_overflow_width = "Always"
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
config.underline_thickness = 1
config.underline_position = -2
config.line_height = 1

config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.native_macos_fullscreen_mode = true
config.window_background_opacity = 1
config.macos_window_background_blur = 0

config.color_scheme = 'Ashes (base16)'
config.macos_window_background_blur = 10

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
  { key = "P",     mods = "CMD|SHIFT", action = wezterm.action.ActivateCommandPalette },
}

wezterm.on("window-resized", function(window, _)
  local w_d = window:get_dimensions()
  local w_s = window:active_tab():get_size()
  local w_key = string.format("%d:%dx%d", window:window_id(), w_d.pixel_width, w_d.pixel_height)

  if wezterm.GLOBAL.fit_key == w_key then return end
  wezterm.GLOBAL.fit_key = w_key

  local overrides = window:get_config_overrides() or {}
  local cell_h, rows = w_s.pixel_height / w_s.rows, w_s.rows
  local current = overrides.font_size or config.font_size
  local target = w_d.pixel_height / (rows * cell_h)

  overrides.font_size = current * target * 0.995
  overrides.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

  wezterm.GLOBAL.pad_pending = w_key

  window:set_config_overrides(overrides)
end)

wezterm.on("window-config-reloaded", function(window, _)
  local w_d = window:get_dimensions()
  local w_s = window:active_tab():get_size()
  local w_key = string.format("%d:%dx%d", window:window_id(), w_d.pixel_width, w_d.pixel_height)

  if wezterm.GLOBAL.pad_pending ~= w_key then return end
  wezterm.GLOBAL.pad_pending = nil

  local overrides = window:get_config_overrides() or {}

  local top = math.floor(w_d.pixel_height % (w_s.pixel_height / w_s.rows))

  overrides.window_padding = { left = 0, right = 0, top = top, bottom = 0 }

  window:set_config_overrides(overrides)
end)

return config
