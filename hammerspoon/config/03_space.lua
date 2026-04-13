-- local log = require("utils.00_log")

local function init_space_hotkeys()
  local function goToSpace(direction)
    local allSpaces = hs.spaces.allSpaces()
    local activeSpaces = hs.spaces.activeSpaces()
    local focusedSpace = hs.spaces.focusedSpace()

    assert(allSpaces, "Spaces did not found.")
    assert(activeSpaces, "Active spaces did not found.")

    for key, value in pairs(activeSpaces) do
      if value == focusedSpace then
        for idx, space_id in pairs(allSpaces[key]) do
          if direction == "H" then
            if idx == 1 and focusedSpace == space_id then
              hs.spaces.gotoSpace(allSpaces[key][#allSpaces[key]])
            elseif focusedSpace == space_id then
              hs.spaces.gotoSpace(allSpaces[key][idx - 1])
            end
          elseif direction == "L" then
            if idx == #allSpaces[key] and focusedSpace == space_id then
              hs.spaces.gotoSpace(allSpaces[key][1])
            elseif focusedSpace == space_id then
              hs.spaces.gotoSpace(allSpaces[key][idx + 1])
            end
          end
        end
      end
    end
  end

  hs.hotkey.bind({ "cmd" }, "H", function()
    goToSpace("H")
  end)
  hs.hotkey.bind({ "cmd" }, "L", function()
    goToSpace("L")
  end)
end


return init_space_hotkeys
