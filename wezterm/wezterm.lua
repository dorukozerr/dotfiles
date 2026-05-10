local wezterm = require "wezterm"
local config = wezterm.config_builder()

require("conf.fonts").apply(config)
require("conf.appearance").apply(config)
require("conf.theme").apply(config)
require("conf.performance").apply(config)
require("conf.keys").apply(config)

return config
