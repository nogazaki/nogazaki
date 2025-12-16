local M = require('solver'):new()

--------------------------------------------------

function M:parse_input(file)
  self.elves = {}
  local calories = 0

  for line in file:lines() do
    local c = line:match('%d+')
    if c then
      calories = calories + c
    else
      table.insert(self.elves, calories)
      calories = 0
    end
  end

  table.sort(self.elves, function(a, b) return a > b end)
end

function M:part_1() return self.elves[1] end

function M:part_2() return self.elves[1] + self.elves[2] + self.elves[3] end

--------------------------------------------------

return M
