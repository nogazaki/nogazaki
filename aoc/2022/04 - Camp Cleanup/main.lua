local input = 'input.txt'

local subsets = 0
local overlap = 0

for line in io.lines(input) do
   local a1, a2, b1, b2 = line:match("(%d+)%-(%d+),(%d+)%-(%d+)")
   a1, a2, b1, b2 = tonumber(a1), tonumber(a2), tonumber(b1), tonumber(b2)

   if ((a1 <= b1) and (a2 >= b2)) or ((a1 >= b1) and (a2 <= b2)) then subsets = subsets + 1 end
   if ((a1 <= b1) and (b1 <= a2)) or ((b1 <= a1) and (a1 <= b2)) then overlap = overlap + 1 end
end

print("Part 1:", subsets)
print("Part 2:", overlap)
