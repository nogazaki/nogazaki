local M = require('solver'):new()

--------------------------------------------------

local function type_to_priority(item)
  local l_item = string.lower(item)
  local offset = item == l_item and 1 or 27

  return string.byte(l_item) - string.byte('a') + offset
end

--------------------------------------------------

function M:parse_input(file)
  self.lines = {}

  for line in file:lines() do
    table.insert(self.lines, line)
  end
end

function M:part_1()
  local total = 0

  for _, line in ipairs(self.lines) do
    local s = line:sub(1, #line / 2) .. '#' .. line:sub(#line / 2 + 1)
    local common = s:match('^.*(.).*#.*%1.*$')
    total = total + type_to_priority(common)
  end

  return total
end

function M:part_2()
  local total = 0

  local n = #self.lines
  for i = 0, n / 3 - 1 do
    local s = self.lines[i * 3 + 1] .. '#' .. self.lines[i * 3 + 2] .. '#' .. self.lines[i * 3 + 3]
    local common = s:match('^.*(.).*#.*%1.*#.*%1.*$')
    total = total + type_to_priority(common)
  end

  return total
end

--------------------------------------------------

return M
