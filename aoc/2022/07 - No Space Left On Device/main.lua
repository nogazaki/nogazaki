local input = 'input.txt'

local total = 70000000
local need = 30000000

local root = { _dir = "/" }

local current
local function get_dir_table(dir)
   local retval = root
   for key in dir:gmatch("[^/]+") do
      retval = retval[key]
   end
   return retval
end

for line in io.lines(input) do
   if line:match("%$") then
      if line:match("cd") then
         local dir = line:match("cd%s*(.-)%s*$")
         if dir == "/" then
            current = "/"
         elseif dir == ".." then
            current = current:match("^(.*/)[^/]+/$")
         else
            current = current .. dir .. "/"
         end
      end
   else
      local first, second = line:match("^(%S+)%s*(%S+)$")
      get_dir_table(current)[second] = first:match("dir") and
          { _dir = current .. second .. "/" } or tonumber(first)
   end
end

local sizes = {}
local sum = 0
local function get_dir_size(dest)
   if type(dest) == "number" then return dest end

   local size = 0
   for key, entry in pairs(dest) do
      if key ~= "_dir" then size = size + get_dir_size(entry) end
   end

   sum = sum + (size < 100000 and size or 0)
   table.insert(sizes, { size = size, dir = dest._dir })

   return size
end

local available = total - get_dir_size(root)

local to_delete
table.sort(sizes, function(a, b) return a.size > b.size end)
for i, dir in ipairs(sizes) do
   local to_be_available = available + dir.size
   if to_be_available < need then
      to_delete = sizes[i - 1].size
      break
   end
end

print("Part 1:", sum)
print("Part 2:", to_delete)
