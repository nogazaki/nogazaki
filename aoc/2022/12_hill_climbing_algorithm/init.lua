local solver = require('solver'):new()

--------------------------------------------------

local function movable(from, to)
  return to and to - from <= 1
end

function solver:solve(flag)
  local queue = {}
  table.insert(queue, 1, { self.me, 0 })
  if flag then
    for _, point in ipairs(self.lowests) do
      table.insert(queue, 1, { point, 0 })
    end
  end

  local set = {}

  while true do
    local pos, d = table.unpack(table.remove(queue, 1))

    if not set[pos[1] .. ',' .. pos[2]] then
      set[pos[1] .. ',' .. pos[2]] = true
      if pos[1] == self.dest[1] and pos[2] == self.dest[2] then
        return d
      end

      for _, delta in ipairs({ { -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 } }) do
        local r, c = pos[1] + delta[1], pos[2] + delta[2]
        if movable(self.grid[pos[1]][pos[2]], self.grid[r][c]) then
          table.insert(queue, { { r, c }, d + 1 })
        end
      end
    end
  end
end

--------------------------------------------------

function solver:parse_input(input_file)
  self.lowests = {}
  self.grid = setmetatable({}, {
    __index = function()
      return {}
    end,
  })

  local r = 1
  local file = assert(io.open(input_file))
  for line in file:lines() do
    local row = {}
    for c = 1, #line do
      local height = line:sub(c, c)
      if height == 'S' then
        self.me = { r, c }
        row[c] = 1
      elseif height == 'E' then
        self.dest = { r, c }
        row[c] = 26
      else
        if height == 'a' then
          table.insert(self.lowests, { r, c })
        end
        row[c] = string.byte(height) - string.byte('a') + 1
      end
    end

    table.insert(self.grid, row)
    r = r + 1
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
