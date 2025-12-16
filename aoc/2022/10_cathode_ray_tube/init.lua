local M = require('solver'):new()

--------------------------------------------------

function M:parse_input(file)
  local CYCLES = '[20][60][100][140][180][220]'

  self.total = 0
  self.crt = ''

  local cycle = 1
  local reg = 1

  local function end_cycle()
    if CYCLES:match('%[' .. cycle .. '%]') then self.total = self.total + reg * cycle end

    local col = (cycle - 1) % 40
    self.crt = self.crt .. (col == 0 and '\n' or '')
    self.crt = self.crt .. (math.abs(reg - col) <= 1 and '#' or '.')

    cycle = cycle + 1
  end

  for line in file:lines() do
    local num = line:match('%a+%s+(-?%d+)')
    if num then
      -- addx instruction
      num = tonumber(num)

      end_cycle()
      end_cycle()
      reg = reg + num
    else
      -- noop instruction
      end_cycle()
    end
  end
end

function M:part_1() return self.total end

function M:part_2() return self.crt end

--------------------------------------------------

return M
