local input = 'input.txt'

local function type_to_priority(item)
   if item == string.lower(item) then
      return string.byte(item) - string.byte("a") + 1
   else
      return string.byte(item) - string.byte("A") + 1 + 26
   end
end

local function solution_1()
   local total = 0

   for line in io.lines(input) do
      local c1, c2 = line:sub(1, #line / 2), line:sub(#line / 2 + 1)
      for item in c1:gmatch(".") do
         if c2:match(item) then
            total = total + type_to_priority(item)
            break
         end
      end
   end

   return total
end

local function solution_2()
   local total = 0

   local file = io.open(input, "r")
   if not file then return end

   while true do
      local c1, c2, c3 = file:read(), file:read(), file:read()
      if not (c1 and c2 and c3) then break end

      for item in c1:gmatch(".") do
         if c2:match(item) and c3:match(item) then
            total = total + type_to_priority(item)
            break
         end
      end
   end
   file:close()

   return total
end

print("Part 1:", solution_1())
print("Part 2:", solution_2())
