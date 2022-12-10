local input = 'input.txt'

local cycles = "[20][60][100][140][180][220]"
local CRT = ""

local function solution()
   -- cycle in execution
   local cycle = 1
   -- register X value
   local reg = 1
   local total = 0

   local function end_cycle()
      if cycles:match("%[" .. cycle .. "%]") then
         total = total + reg * cycle
      end

      local col = (cycle - 1) % 40
      CRT = CRT .. (col == 0 and "\n" or "")
      CRT = CRT .. (math.abs(reg - col) <= 1 and "#" or ".")

      cycle = cycle + 1
   end

   for line in io.lines(input) do
      local _, num = line:match("(%a+)%s+(-?%d+)")

      -- addx instruction
      if num then
         num = tonumber(num)

         end_cycle()
         end_cycle()
         reg = reg + num

         -- noop instruction
      else
         end_cycle()
      end
   end

   return total
end

print("Part 1:", solution())
print("Part 2:", CRT)
