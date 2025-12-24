local M = {}

--------------------------------------------------

local colors = require('utils').colors
local function unimplemented(...) end
local function colors_res(text) return text and colors.bold(colors.yellow(text)) or colors.red('<unimplemented>') end

--------------------------------------------------

M.__index = M
M.parse_input = unimplemented
M.part_1 = unimplemented
M.part_2 = unimplemented

function M:new() return setmetatable({}, self) end

function M:execute(input_file)
  local file = assert(io.open(input_file))
  local timer = os.clock()

  self:parse_input(file)
  local result_1 = self:part_1()
  local result_2 = self:part_2()

  timer = os.clock() - timer
  file:close()

  local result = ''
  result = result .. 'part 1: ' .. colors_res(result_1) .. '\n'
  result = result .. 'part 2: ' .. colors_res(result_2) .. '\n'
  result = result .. string.format('took ' .. colors_res('%.3fms') .. ' in total', timer * 1000)

  return result
end

--------------------------------------------------

return M
