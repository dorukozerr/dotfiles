local function init_caffeine()
  local caffeine = hs.menubar.new()

  local function setCaffeineDisplay(state)
    if state and caffeine then
      caffeine:setTitle("tryhard mode on")
    elseif caffeine then
      caffeine:setTitle("chillin")
    end
  end

  local function caffeineClicked()
    setCaffeineDisplay(hs.caffeinate.toggle("displayIdle"))
  end

  if caffeine then
    caffeine:setClickCallback(caffeineClicked)
    setCaffeineDisplay(hs.caffeinate.get("displayIdle"))
  end
end

return init_caffeine
