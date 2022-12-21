local input = 'input.txt'

local monkeys = {}
for line in io.lines(input) do
   local matcher = line:gmatch("%a%a%a%a")
   local current = matcher()

   local first, second = matcher(), matcher()
   if first and second then
      monkeys[current] = {
         first = first,
         second = second,
         operator = line:match(first .. "%s*([%+%-%*/])%s*" .. second)
      }
   else
      monkeys[current] = tonumber(line:match("%-?%d+"))
   end
end

local function hear_the_monkey(name)
   local monkey = monkeys[name]

   if type(monkey) == "number" then return monkey end
   if type(monkey) ~= "table" then return end

   local first = hear_the_monkey(monkey.first)
   local second = hear_the_monkey(monkey.second)

   if monkey.operator == "+" then
      return first + second
   elseif monkey.operator == "-" then
      return first - second
   elseif monkey.operator == "*" then
      return first * second
   elseif monkey.operator == "/" then
      return first / second
   end
end

print("Part 1:", string.format("%d", hear_the_monkey("root")))

monkeys.humn = nil
local target, human_side
for _, name in pairs { monkeys.root.first, monkeys.root.second } do
   local success, value = pcall(hear_the_monkey, name)
   if success then
      target = value
      human_side = (name == monkeys.root.first) and monkeys.root.second or monkeys.root.first
      break
   end
end

local x1, y1, x2, y2
x1 = 0; monkeys.humn = x1; y1 = hear_the_monkey(human_side)
x2 = 2 ^ 64; monkeys.humn = x2; y2 = hear_the_monkey(human_side)

print("Part 2:", string.format("%d", (target - y1) / (y2 - y1) * (x2 - x1) - x1))
