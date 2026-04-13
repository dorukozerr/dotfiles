hs.alert.show("Hammerspoon loaded")

local c_folder = hs.fs.fileListForPath('config', { relativePath = true })

assert(c_folder, 'Config folder does not include any file.')

for c_index, c_file in pairs(c_folder) do
  local init_func = string.format("config_%d", c_index)
  local mod = string.gsub(string.format("%s.%s", "config", c_file), ".lua", "")
  init_func = require(mod)
  init_func()
end
