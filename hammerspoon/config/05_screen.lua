-- local log = require("utils.00_log")

local function init_screen_hotkeys()
  for _, screen in pairs({ "1", "2", "3" }) do
    hs.hotkey.bind({ "cmd", "ctrl" }, screen, function()
      local allSpaces = hs.spaces.allSpaces()
      local activeSpaces = hs.spaces.activeSpaces()
      local focusedSpace = hs.spaces.focusedSpace()

      assert(allSpaces, "Spaces did not found.")
      assert(activeSpaces, "Active spaces did not found.")

      local screen_idx = 1

      hs.alert.show(hs.inspect(allSpaces))
      hs.alert.show(hs.inspect(activeSpaces))
      hs.alert.show(hs.inspect(focusedSpace))

      for screen_id, _ in pairs(allSpaces) do
        if screen == string.format("%d", screen_idx) then
          local target_to_focus = hs.screen.find(screen_id):fullFrame().center
          hs.mouse.absolutePosition(target_to_focus)
          hs.eventtap.leftClick(target_to_focus)
          return
        end
        screen_idx = screen_idx + 1
      end
    end)
  end
end

return init_screen_hotkeys
