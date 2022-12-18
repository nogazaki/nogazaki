local input = 'input.txt'

local function main(do_part_2)
   local stacks = {}

   for line in io.lines(input) do
      if not line:match("%d") then
         line = (" " .. line):gsub("    ", " [ ]"):match("^[%s\r\n]*(.-)[%s\r\n]*$")

         local i = 0
         for crate in line:gmatch("%[(.)%]") do
            i = i + 1; stacks[i] = stacks[i] or {}
            if crate ~= " " then table.insert(stacks[i], 1, crate) end
         end
      elseif line:match("move") then
         local n, src, dst = line:match("(%d+).-(%d+).-(%d+)")
         n, src, dst = tonumber(n), tonumber(src), tonumber(dst)

         for i = n - 1, 0, -1 do
            table.insert(
               stacks[dst],
               table.remove(stacks[src], #stacks[src] - (do_part_2 and i or 0))
            )
         end
      end
   end

   local top = ""
   for _, stack in ipairs(stacks) do
      top = top .. stack[#stack]
   end

   return top
end


print("Part 1:", main())
print("Part 2:", main(true))
