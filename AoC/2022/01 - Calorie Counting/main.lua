local input = "input.txt"

local function solution(top)
   local calories = 0
   local elfs = {}

   for line in io.lines(input) do
      local c = line:match("%d+")
      if c then
         calories = calories + c
      else
         table.insert(elfs, calories)
         calories = 0
      end
   end

   table.sort(elfs, function(a, b) return a > b end)

   local total = 0
   for i = 1, top do
      total = total + elfs[i]
   end

   return total
end

print("Part 1:", solution(1))
print("Part 2:", solution(3))
