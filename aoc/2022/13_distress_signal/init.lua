pcall(require, 'luarocks.loader')
local json = require('JSON')
local utils = require('utils')

local solver = require('solver'):new()

--------------------------------------------------

local function compare(left, right)
  if not left and not right then
    return
  end
  if left and not right then
    return false
  end
  if not left and right then
    return true
  end

  if type(left) == 'number' and type(right) == 'number' then
    if left < right then
      return true
    end
    if right < left then
      return false
    end
    return
  end

  if type(left) == 'number' then
    left = { left }
  end
  if type(right) == 'number' then
    right = { right }
  end

  for i = 1, #left + 1 do
    local ret = compare(left[i], right[i])
    if ret ~= nil then
      return ret
    end
  end
end

--------------------------------------------------

function solver:parse_input(input_file)
  self.packets = {}

  local file = assert(io.open(input_file))
  for line in file:lines() do
    local packet = json:decode(line)
    table.insert(self.packets, packet)
  end

  file:close()
end

function solver:part_1()
  local res = 0
  for i = 0, #self.packets / 2 - 1 do
    res = res + (compare(self.packets[i * 2 + 1], self.packets[i * 2 + 2]) and i + 1 or 0)
  end

  return res
end

function solver:part_2()
  local res = 1
  local packets = utils.copy(self.packets)

  local div_1 = json:decode('[[2]]')
  local div_2 = json:decode('[[6]]')

  table.insert(packets, div_1)
  table.insert(packets, div_2)
  table.sort(packets, compare)

  for index, packet in ipairs(packets) do
    if packet == div_1 or packet == div_2 then
      res = res * index
    end
  end

  return res
end

--------------------------------------------------

return solver
