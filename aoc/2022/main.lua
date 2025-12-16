local lfs = require('lfs')
local colors = require('utils').colors

local solutions = {}
local choices = {}

for _, a in ipairs(arg) do
  local index = tonumber(a)
  if index then
    choices[index] = true
  else
    print('Unknown argument')
  end
end

for entry in lfs.dir('.') do
  local _, _, index = entry:find('^(%d%d).+$')
  solutions[tonumber(index) or 0] = entry
end

for day, module_name in ipairs(solutions) do
  if #arg == 0 or choices[day] then
    local header = 'day ' .. module_name:gsub('_', ': ', 1):gsub('_', ' ')
    local separator = string.rep('-', #header)
    local ok, solver = pcall(require, module_name)

    print(separator)
    if ok then
      print(colors.green(header))
      print(solver:execute('./' .. module_name .. '/input.txt'))
    else
      print(colors.red(header))
      print('solution not found')
    end
  end
end
