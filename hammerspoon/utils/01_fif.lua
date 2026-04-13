-- Functional-if
local function fif(condition, if_true, if_false)
  if condition then return if_true else return if_false end
end

return fif
