local M = { colors = {} }

--------------------------------------------------

local reset = '\27[0m'
local colors = {
  bold = '\27[1m',
  red = '\27[31m',
  green = '\27[32m',
  yellow = '\27[33m',
}

for name, code in pairs(colors) do
  M.colors[name] = function(text)
    return code .. text .. reset
  end
end

--------------------------------------------------

function M.copy(obj)
  if type(obj) ~= 'table' then
    return obj
  end
  local res = {}
  for k, v in pairs(obj) do
    res[k] = M.copy(v)
  end
  return res
end

--------------------------------------------------

return M
