local solver = require('solver'):new()

--------------------------------------------------

function solver:solve(flag)
  while true do
    if self.grid[500][0] then
      return self.total
    end

    local sand = { x = 500, y = 0 }
    while true do
      if not flag and (sand.y == self.deepest) then
        sand.void = true
        break
      end

      local x, y = sand.x, sand.y

      if not self.grid[x][y + 1] then
        sand.y = y + 1
      elseif not self.grid[x - 1][y + 1] then
        sand.x = x - 1
        sand.y = y + 1
      elseif not self.grid[x + 1][y + 1] then
        sand.x = x + 1
        sand.y = y + 1
      else
        self.grid[x][y] = 'o'
        break
      end
    end

    if sand.void then
      return self.total
    end
    self.total = self.total + 1
  end
end

--------------------------------------------------

function solver:parse_input(input_file)
  self.total = 0
  self.deepest = 0

  local grid_mt_mt = {}
  function grid_mt_mt.__index(_, y)
    return y == self.deepest + 2 and '#' or nil
  end

  local grid_mt = {}
  function grid_mt.__index(this, x)
    return rawset(this, x, setmetatable({}, grid_mt_mt))[x]
  end

  self.grid = setmetatable({}, grid_mt)

  local file = assert(io.open(input_file))
  for line in file:lines() do
    local xlast, ylast
    for x, y in line:gmatch('(%d+),(%d+)') do
      x, y = tonumber(x), tonumber(y)
      if not xlast then
        goto continue
      end

      for i = math.min(xlast, x), math.max(xlast, x) do
        for j = math.min(ylast, y), math.max(ylast, y) do
          self.grid[i][j] = '#'
        end
      end

      ::continue::
      xlast, ylast = x, y
      self.deepest = math.max(self.deepest, ylast)
    end
  end

  file:close()
end

function solver:part_1()
  return self:solve(false)
end

function solver:part_2()
  return self:solve(true)
end

--------------------------------------------------

return solver

-- local total = 0
--
--
-- print('Part 1:', solution())
-- print('Part 2:', solution(true))
