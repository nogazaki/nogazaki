local colors = require('utils').colors

local solver = {}

---@diagnostic disable-next-line: unused-vararg
local function unimplemented(...) end

local function colors_res(text)
  return text and colors.bold(colors.yellow(text)) or colors.red('<unimplemented>')
end

solver.__index = solver
solver.parse_input = unimplemented
solver.part_1 = unimplemented
solver.part_2 = unimplemented

function solver:new()
  local s = {}
  setmetatable(s, self)
  return s
end

function solver:execute(input_file)
  local timer

  timer = os.clock()

  self:parse_input(input_file)
  local result_1 = self:part_1()
  local result_2 = self:part_2()

  local total_time = os.clock() - timer

  local result = ''

  result = result .. 'part 1: ' .. colors_res(result_1) .. '\n'
  result = result .. 'part 2: ' .. colors_res(result_2) .. '\n'

  result = result .. string.format('took ' .. colors_res('%.3fms') .. ' in total', total_time * 1000)

  return result
end

return solver
