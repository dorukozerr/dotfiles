local wezterm = require "wezterm"
local M = {}

function M.apply(config)
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
end

return M
