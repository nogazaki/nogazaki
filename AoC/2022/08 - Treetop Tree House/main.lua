local input = 'input.txt'

local forest = {};

for line in io.lines(input) do
   local row = {}
   line:gsub("%d", function(c) table.insert(row, tonumber(c)) end)

   table.insert(forest, row)
end

local visible_count = 0
local scenic_score = 0

for y = 1, #forest do
   for x = 1, #forest[1] do
      local tree = forest[y][x]
      local tree_visibility = { true, true, true, true }
      local distance = { 0, 0, 0, 0 }

      for i = x - 1, 1, -1 do
         distance[1] = distance[1] + 1
         if forest[y][i] >= tree then
            tree_visibility[1] = false
            break
         end
      end

      for i = x + 1, #forest[1] do
         distance[2] = distance[2] + 1
         if forest[y][i] >= tree then
            tree_visibility[2] = false
            break
         end
      end

      for i = y - 1, 1, -1 do
         distance[3] = distance[3] + 1
         if forest[i][x] >= tree then
            tree_visibility[3] = false
            break
         end
      end

      for i = y + 1, #forest do
         distance[4] = distance[4] + 1
         if forest[i][x] >= tree then
            tree_visibility[4] = false
            break
         end
      end

      if tree_visibility[1] or tree_visibility[2] or tree_visibility[3] or tree_visibility[4] then
         visible_count = visible_count + 1
      end

      scenic_score = math.max(scenic_score, distance[1] * distance[2] * distance[3] * distance[4])
   end
end

print("Part 1:", visible_count)
print("Part 2:", scenic_score)
