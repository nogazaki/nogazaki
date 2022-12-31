local input = 'input.txt'

local lines = {}
for line in io.lines(input) do table.insert(lines, line) end

local me, dest, lowests = {}, {}, {}
local grid = setmetatable({}, { __index = function() return {} end })
for r = 1, #lines do
   grid[r] = {}

   for c = 1, #lines[1] do
      local height = lines[r]:sub(c, c)
      if height == "S" then
         grid[r][c] = 1
         me = { r, c }
      elseif height == "E" then
         grid[r][c] = 26
         dest = { r, c }
      else
         if height == "a" then table.insert(lowests, { r, c }) end
         grid[r][c] = string.byte(height) - string.byte("a") + 1
      end
   end
end

local function movable(from, to) return to and to - from <= 1 end

local function solution(do_part_2)
   local queue = {}
   table.insert(queue, 1, { me, 0 })
   if do_part_2 then
      for _, point in ipairs(lowests) do
         table.insert(queue, 1, { point, 0 })
      end
   end

   local set = {}

   while true do
      local pos, d = table.unpack(table.remove(queue, 1))

      if not set[pos[1] .. "," .. pos[2]] then
         set[pos[1] .. "," .. pos[2]] = true
         if pos[1] == dest[1] and pos[2] == dest[2] then
            return d
         end

         for _, delta in ipairs({ { -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 } }) do
            local r, c = pos[1] + delta[1], pos[2] + delta[2]
            if movable(grid[pos[1]][pos[2]], grid[r][c]) then
               table.insert(queue, { { r, c }, d + 1 })
            end
         end
      end
   end
end

print("Part 1:", solution())
print("Part 2:", solution(true))
