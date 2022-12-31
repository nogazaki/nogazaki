local input = 'input.txt'

local function solution(number_of_knots)
   -- coords
   local knots = {}
   for i = 1, number_of_knots do
      knots[i] = { x = 0, y = 0 }
   end

   -- table to store unique coords that the final tail visits
   local visited = {}
   visited.count = 0

   for line in io.lines(input) do
      local dir, steps = line:match("(%a)%s+(%d+)")

      for _ = 1, tonumber(steps) do
         -- moving head
         knots[1].x = knots[1].x + (dir == "R" and 1 or (dir == "L" and -1 or 0))
         knots[1].y = knots[1].y + (dir == "U" and 1 or (dir == "D" and -1 or 0))

         -- moving other knots
         for k = 2, number_of_knots do
            local head, tail = knots[k - 1], knots[k]
            if not (math.abs(head.x - tail.x) <= 1 and math.abs(head.y - tail.y) <= 1) then
               tail.x = tail.x + (head.x == tail.x and 0 or (head.x > tail.x and 1 or -1))
               tail.y = tail.y + (head.y == tail.y and 0 or (head.y > tail.y and 1 or -1))
            end
         end

         local str = string.format("%d,%d", knots[number_of_knots].x, knots[number_of_knots].y)
         if not visited[str] then
            visited[str] = true
            visited.count = visited.count + 1
         end
      end
   end

   return visited.count
end

print("Part 1:", solution(2))
print("Part 2:", solution(10))
