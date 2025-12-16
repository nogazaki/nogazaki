local M = require('solver'):new()

--------------------------------------------------

local function move_knots_once(knots, dir)
  knots[1].x = knots[1].x + (dir == 'R' and 1 or (dir == 'L' and -1 or 0))
  knots[1].y = knots[1].y + (dir == 'U' and 1 or (dir == 'D' and -1 or 0))

  for k = 2, #knots do
    local head, tail = knots[k - 1], knots[k]
    if not (math.abs(head.x - tail.x) <= 1 and math.abs(head.y - tail.y) <= 1) then
      tail.x = tail.x + (head.x == tail.x and 0 or (head.x > tail.x and 1 or -1))
      tail.y = tail.y + (head.y == tail.y and 0 or (head.y > tail.y and 1 or -1))
    end
  end
end

function M:move_knots(number_of_knots)
  local knots = {}
  for i = 1, number_of_knots do
    knots[i] = { x = 0, y = 0 }
  end

  local visited = setmetatable({}, { __index = function(this, key) rawset(this, key, 0) end })
  visited.count = 0

  for _, move in ipairs(self.moves) do
    for _ = 1, tonumber(move.steps) do
      move_knots_once(knots, move.dir)

      local key = knots[number_of_knots].x * 1000 + knots[number_of_knots].y
      visited.count = visited.count + (visited[key] or 1)
    end
  end

  return visited.count
end

--------------------------------------------------

function M:parse_input(file)
  self.moves = {}
  for line in file:lines() do
    local dir, steps = line:match('(%a)%s+(%d+)')
    table.insert(self.moves, { dir = dir, steps = steps })
  end
end

function M:part_1() return self:move_knots(2) end

function M:part_2() return self:move_knots(10) end

--------------------------------------------------

return M
