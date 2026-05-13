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
      orientation = { Radial = { cx = 0.8, cy = 0.8, radius = 1.5 } },
      colors = {
        tostring(wezterm.color.parse(scheme.ansi[3]):darken(0.88)),
        tostring(wezterm.color.parse(scheme.ansi[5]):darken(0.78)),
        tostring(wezterm.color.parse(scheme.ansi[7]):darken(0.9)),
      },
      interpolation = "CatmullRom",
      blend = "LinearRgb",
    }
  end
end

return M
