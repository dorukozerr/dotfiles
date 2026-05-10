local M = {}

function M.apply(config)
  config.scrollback_lines = 5000
  -- requires the wezterm terminfo to be installed; remove if programs misbehave
  config.term = "wezterm"
  config.max_fps = 240
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "HighPerformance"
  config.animation_fps = 120
end

return M
