local input = 'input.txt'

local decrypt_key = 811589153

local function get_nodes()
   local start, nodes = nil, {}
   local first, last
   for line in io.lines(input) do
      local node = { prev = last, number = tonumber(line) }
      table.insert(nodes, node)

      if node.number == 0 then start = node end

      if not first then first = node end
      if last then last.next = node end
      last = node
   end
   last.next = first
   first.prev = last

   start.length = #nodes
   return start, nodes
end
local function move_node(node, length, decrypted)
   length = length - 1
   local steps = node.number * (decrypted and decrypt_key or 1) % length
   if steps == 0 then return end
   steps = (steps < length / 2) and steps or (steps - length)

   -- Decouple the node
   node.prev.next = node.next; node.next.prev = node.prev

   -- Reconnect the node
   local new_position = node
   if steps > 0 then
      for _ = 1, math.abs(steps) do new_position = new_position.next end
      node.next = new_position.next; new_position.next = node
      node.next.prev = node; node.prev = new_position
   elseif steps < 0 then
      for _ = 1, math.abs(steps) do new_position = new_position.prev end
      node.prev = new_position.prev; new_position.prev = node
      node.prev.next = node; node.next = new_position
   end
end
local function get_node_at_position(start, position)
   local tmp = start
   for _ = 1, position do tmp = tmp.next end
   return tmp
end

local start, nodes

start, nodes = get_nodes()
for _, node in ipairs(nodes) do move_node(node, #nodes) end
print("Part 1:",
   get_node_at_position(start, 1000).number +
   get_node_at_position(start, 2000).number +
   get_node_at_position(start, 3000).number
)

start, nodes = get_nodes()
for _ = 1, 10 do
   for _, node in ipairs(nodes) do move_node(node, #nodes, true) end
end
print("Part 2:", decrypt_key * (
   get_node_at_position(start, 1000).number +
   get_node_at_position(start, 2000).number +
   get_node_at_position(start, 3000).number
))
