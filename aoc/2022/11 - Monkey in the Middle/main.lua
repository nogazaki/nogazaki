local input = 'input.txt'

local lines = {}
for line in io.lines(input) do table.insert(lines, line) end

local function parse_input()
   local monkeys = { lcm = 1 }

   local n = 1

   while n <= #lines do
      if lines[n] ~= '' then
         local monkey = { items = {} }
         monkey.id = lines[n]:match("Monkey (%d+):") + 1

         local items = lines[n + 1]:match("Starting items:(.+)")
         for item in items:gmatch("(%d+)") do
            table.insert(monkey.items, item)
         end

         local op = lines[n + 2]:match("Operation: new = (.+)")
         monkey.op = load("return " .. op:gsub("old", "..."))

         monkey.mod = lines[n + 3]:match("%d+")

         monkey[true] = lines[n + 4]:match("%d+") + 1
         monkey[false] = lines[n + 5]:match("%d+") + 1

         table.insert(monkeys, monkey)
         monkeys.lcm = monkeys.lcm * monkey.mod

         n = n + 6
      else
         n = n + 1
      end
   end

   return monkeys
end

local function solution(round, div)
   local monkeys = parse_input()
   local counts = {}

   for _ = 1, round do
      for i, monkey in ipairs(monkeys) do
         for _, item in ipairs(monkey.items) do
            item = math.floor(monkey.op(item) / div)
            item = item % monkeys.lcm -- ???

            local test = item % monkey.mod == 0
            table.insert(monkeys[monkey[test]].items, item)

            counts[i] = (counts[i] or 0) + 1
         end

         monkey.items = {}
      end
   end

   table.sort(counts, function(a, b) return a > b end)
   return (counts[1] or 0) * (counts[2] or 0)
end

print("Part 1:", solution(20, 3))
print("Part 2:", solution(10000, 1))
