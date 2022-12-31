local input = 'input.txt'

local function find_the_index(data, second_part)
   local offset = second_part and 14 or 4

   for i = offset, #data do
      if not data:sub(i - offset + 1, i):find("(.).*(%1)") then return i end
   end
end

local result1, result2
if input:match("sample") then
   for line in io.lines(input) do
      result1 = (result1 or "") .. find_the_index(line) .. "; "
      result2 = (result2 or "") .. find_the_index(line, true) .. "; "
   end
else
   local f = io.open(input)
   if not f then return end
   local data = f:read("a")
   f:close()
   result1 = find_the_index(data)
   result2 = find_the_index(data, true)
end

print("Part 1:", result1)
print("Part 2:", result2)
