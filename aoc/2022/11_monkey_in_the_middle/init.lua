local utils = require('utils')

local solver = require('solver'):new()

--------------------------------------------------

local FORMAT = [[Monkey (%d-):
  Starting items: (.-)
  Operation: new = (.-)
  Test: divisible by (%d-)
    If true: throw to monkey (%d-)
    If false: throw to monkey (%d-)
]]

function solver:solve(round, div)
  local monkeys = utils.copy(self.monkeys)
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

--------------------------------------------------

function solver:parse_input(file)
  self.monkeys = { lcm = 1 }

  for id, items, op, test, pos, neg in file:read('*a'):gmatch(FORMAT) do
    local monkey = { id = id, items = {}, mod = test, [true] = pos + 1, [false] = neg + 1 }
    monkey.op = load('return ' .. op:gsub('old', '...'))
    for item in items:gmatch('(%d+)') do
      table.insert(monkey.items, item)
    end

    table.insert(self.monkeys, monkey)
    self.monkeys.lcm = self.monkeys.lcm * test
  end
end

function solver:part_1() return self:solve(20, 3) end

function solver:part_2() return self:solve(10000, 1) end

--------------------------------------------------

return solver
