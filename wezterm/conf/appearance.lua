local M = {}

function M.apply(config)
  config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
  config.window_decorations = "RESIZE"
  config.hide_tab_bar_if_only_one_tab = true
  config.window_close_confirmation = "NeverPrompt"
  config.native_macos_fullscreen_mode = true
  config.window_background_opacity = 1
  config.macos_window_background_blur = 0
end

return M
