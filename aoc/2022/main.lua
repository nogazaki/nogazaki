local lfs = require('lfs')
local colors = require('utils').colors

--------------------------------------------------

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

  local ok, solver = pcall(require, entry)
  if ok then solutions[tonumber(index) or 0] = { name = entry, solver = solver } end
end

--------------------------------------------------

for day, module in ipairs(solutions) do
  if #arg == 0 or choices[day] then
    local header = 'day ' .. module.name:gsub('_', ': ', 1):gsub('_', ' ')
    local separator = string.rep('-', #header)
    -- local ok, solver = pcall(require, module)

    print(separator)
    print(colors.green(header))
    print(module.solver:execute('./' .. module.name .. '/input.txt'))
    -- if ok then
    --   print(colors.green(header))
    --   print(solver:execute('./' .. module .. '/input.txt'))
    -- else
    --   print(colors.red(header))
    --   print('solution not found')
    -- end
  end
end
