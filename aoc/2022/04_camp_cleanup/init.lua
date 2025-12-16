local M = require('solver'):new()

--------------------------------------------------

function M:parse_input(file)
  self.subsets = 0
  self.overlap = 0

  for line in file:lines() do
    local a1, a2, b1, b2 = line:match('(%d+)%-(%d+),(%d+)%-(%d+)')
    a1, a2, b1, b2 = tonumber(a1), tonumber(a2), tonumber(b1), tonumber(b2)

    if ((a1 <= b1) and (a2 >= b2)) or ((a1 >= b1) and (a2 <= b2)) then self.subsets = self.subsets + 1 end
    if ((a1 <= b1) and (b1 <= a2)) or ((b1 <= a1) and (a1 <= b2)) then self.overlap = self.overlap + 1 end
  end
end

function M:part_1() return self.subsets end

function M:part_2() return self.overlap end

--------------------------------------------------

return M
