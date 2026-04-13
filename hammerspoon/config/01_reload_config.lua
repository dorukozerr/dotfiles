local function init_reload_config_hotkey()
  hs.hotkey.bind({ "cmd", "shift" }, "R", function()
    hs.reload()
  end)
end

return init_reload_config_hotkey
