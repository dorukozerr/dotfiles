local wezterm = require "wezterm"
local M = {}

function M.apply(config)
  local scheme_name = "mountaineer_dark"

  config.color_scheme = scheme_name

  local ok, scheme = pcall(
    wezterm.color.load_scheme,
    wezterm.config_dir .. "/colors/" .. scheme_name .. ".toml"
  )

  if ok and scheme then
    config.window_background_gradient = {
      orientation = { Radial = { cx = 0.5, cy = 0.5, radius = 1.25 } },
      colors = {
        scheme.ansi[1],
        scheme.background,
        tostring(wezterm.color.parse(scheme.background):darken(0.25)),
      },
      interpolation = "CatmullRom",
      blend = "LinearRgb",
    }
  end
end

return M
