local input = 'input.txt'

local deepest
local grid = setmetatable({}, {
   __index = function(self, x)
      return rawset(self, x, setmetatable({}, {
         __index = function(_, y)
            if y == deepest + 2 then return "#" end
         end
      }))[x]
   end
})
for line in io.lines(input) do
   local x1, x2, y1, y2

   for pos in line:gmatch("%d+,%d+") do
      if not x1 then
         x1, y1 = pos:match("(%d+),(%d+)")
         x1, y1 = tonumber(x1), tonumber(y1)
      else
         x2, y2 = pos:match("(%d+),(%d+)")
         x2, y2 = tonumber(x2), tonumber(y2)

         for x = math.min(x1, x2), math.max(x1, x2) do
            for y = math.min(y1, y2), math.max(y1, y2) do
               grid[x][y] = "#"
            end
         end

         x1 = x2; y1 = y2
      end

      if y1 > (deepest or 0) then deepest = y1 end
   end
end

local total = 0

local function solution(do_part_2)
   while true do
      if grid[500][0] then return total end

      local sand = { x = 500, y = 0 }
      while true do
         if not do_part_2 and (sand.y == deepest) then
            sand.void = true
            break
         end

         local x, y = sand.x, sand.y

         if not grid[x][y + 1] then
            sand.y = y + 1
         elseif not grid[x - 1][y + 1] then
            sand.x = x - 1; sand.y = y + 1
         elseif not grid[x + 1][y + 1] then
            sand.x = x + 1; sand.y = y + 1
         else
            grid[x][y] = "o"
            break
         end
      end

      if sand.void then return total end
      total = total + 1
   end
end

print("Part 1:", solution())
print("Part 2:", solution(true))
