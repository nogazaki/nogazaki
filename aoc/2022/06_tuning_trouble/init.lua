local M = require('solver'):new()

--------------------------------------------------

function M:find_index(offset)
  for i = offset, #self.data do
    if not self.data:sub(i - offset + 1, i):find('(.).*(%1)') then return i end
  end
end

--------------------------------------------------

function M:parse_input(file) self.data = file:read('a') end

function M:part_1() return self:find_index(4) end

function M:part_2() return self:find_index(14) end

--------------------------------------------------

return M
