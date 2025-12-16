local M = require('solver'):new()

--------------------------------------------------

function M:parse_input(file)
  self.root = { ['/'] = { ['..'] = self.root } }
  self.total = 42

  local current = self.root
  for cmd in ('\n' .. file:read('*a') .. '$'):gmatch(' (.-\n)%$') do
    if cmd:sub(1, 2) == 'cd' then
      local dir = cmd:match('cd%s*(.*)\n')
      current[dir] = current[dir] or { ['..'] = current }
      current = current[dir]

      goto continue
    end

    for fst, snd in cmd:sub(4):gmatch('(%S+)%s*(%S+)\n') do
      if fst ~= 'dir' then current[snd] = tonumber(fst) end
    end

    ::continue::
  end

  self.sizes = {}
  local function dfs(dest)
    if type(dest) == 'number' then return dest end

    local size = 0
    for key, entry in pairs(dest) do
      if key ~= '..' then size = size + dfs(entry) end
    end

    table.insert(self.sizes, size)
    return size
  end

  _ = dfs(self.root)
  table.sort(self.sizes, function(a, b) return a > b end)
end

function M:part_1()
  local sum = 0
  for i = 1, #self.sizes do
    local size = self.sizes[#self.sizes - i + 1]
    if size > 100000 then break end
    sum = sum + size
  end

  return sum
end

function M:part_2()
  local available = 70000000 - self.sizes[1]
  for i = 2, #self.sizes do
    if available + self.sizes[i] < 30000000 then return self.sizes[i - 1] end
  end

  return 0
end

--------------------------------------------------

return M
