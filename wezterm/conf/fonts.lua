local wezterm = require "wezterm"
local M = {}

function M.apply(config)
  config.font = wezterm.font("IosevkaTerm NF")
  -- config.font = wezterm.font("CaskaydiaCove Nerd Font")
  config.font_size = 24.0
  config.allow_square_glyphs_to_overflow_width = "Always"
  config.harfbuzz_features = { "calt=1", "clig=1", "liga=1" }
  config.underline_thickness = 1
  config.underline_position = -2
end

return M
