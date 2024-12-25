local input = 'input.txt'

local json = require("JSON")

local function compare(left, right)
   if not left and not right then return end
   if left and not right then return false end
   if not left and right then return true end

   if type(left) == "number" and type(right) == "number" then
      if left < right then return true end
      if right < left then return false end
      return
   end

   if type(left) == "number" then left = { left } end
   if type(right) == "number" then right = { right } end

   for i = 1, #left + 1 do
      local ret = compare(left[i], right[i])
      if ret ~= nil then return ret end
   end
end

local function solution_1()
   local left, right = nil, nil
   local total = 0
   local index = 0

   for line in io.lines(input) do
      if not left then
         left = json:decode(line)
      elseif not right then
         right = json:decode(line)
      else
         left, right = nil, nil
      end

      if left and right then
         index = index + 1
         total = total + (compare(left, right) and index or 0)
      end
   end

   return total
end

local function solution_2()
   local dividers = {
      json:decode("[[2]]"),
      json:decode("[[6]]"),
   }
   local total = 1
   local packets = { dividers[1], dividers[2] }

   for line in io.lines(input) do
      packets[#packets + 1] = json:decode(line)
   end

   table.sort(packets, compare)
   for index, packet in ipairs(packets) do
      if packet == dividers[1] or packet == dividers[2] then
         total = total * index
      end
   end

   return total
end

print("Part 1:", solution_1())
print("Part 2:", solution_2())
