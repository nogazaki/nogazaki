local M = require('solver'):new()

--------------------------------------------------

local utils = require('utils')

function M:do_all_moves(multiple)
  local stacks = utils.copy(self.stacks)

  for _, move in ipairs(self.moves) do
    for i = move.n - 1, 0, -1 do
      local offset = multiple and i or 0
      local removed = table.remove(stacks[move.src], #stacks[move.src] - offset)
      table.insert(stacks[move.dst], removed)
    end
  end

  local top = ''
  for _, stack in ipairs(stacks) do
    top = top .. stack[#stack]
  end

  return top
end

--------------------------------------------------

function M:parse_input(file)
  self.stacks = setmetatable({}, { __index = function(this, key) return rawset(this, key, {})[key] end })
  self.moves = {}

  for line in file:lines() do
    if line:match('move') then
      local n, src, dst = line:match('(%d+).-(%d+).-(%d+)')
      n, src, dst = tonumber(n), tonumber(src), tonumber(dst)
      table.insert(self.moves, { n = n, src = src, dst = dst })

      goto continue
    end

    line = (' ' .. line):gsub('    ', ' [ ]')

    local i = 0
    for crate in line:gmatch('%[(.)%]') do
      i = i + 1
      if crate ~= ' ' then table.insert(self.stacks[i], 1, crate) end
    end

    ::continue::
  end
end

function M:part_1() return self:do_all_moves(false) end

function M:part_2() return self:do_all_moves(true) end

--------------------------------------------------

return M
