local input = 'input.txt'

local ROW, COL

local blizzard = {}
local moves = {
   [">"] = { dr = 0, dc = 1 },
   ["<"] = { dr = 0, dc = -1 },
   ["^"] = { dr = -1, dc = 0 },
   ["v"] = { dr = 1, dc = 0 },
}

for line in io.lines(input) do
   line = line:match("^#(.-)#$")

   if not line:match("#") then
      COL = #line; ROW = (ROW or 0) + 1

      for i = 1, COL do
         local ground = line:sub(i, i)

         if not ground:match("%.") then
            table.insert(blizzard, { r = ROW, c = i, dir = ground })
         end
      end
   end
end

local function movable(row, col, minute_passed)
   for _, b in pairs(blizzard) do
      local r, c
      r = (b.r + minute_passed * moves[b.dir].dr - 1) % ROW + 1
      c = (b.c + minute_passed * moves[b.dir].dc - 1) % COL + 1

      if row == r and col == c then return false end
   end

   return true
end

local function move_around(current, destination)
   table.insert(current, 0)
   local queue, set = {}, {}
   table.insert(queue, 1, current)

   while #queue ~= 0 do
      local r, c, d = table.unpack(table.remove(queue, 1))

      if not set[r .. "," .. c .. "," .. d] then
         set[r .. "," .. c .. "," .. d] = true
         if r == destination[1] and c == destination[2] then return d end

         for _, delta in ipairs({ { 0, 0 }, { -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 } }) do
            local rr, cc = r + delta[1], c + delta[2]
            if (cc >= 1 and cc <= COL and rr >= 1 and rr <= ROW) or
                (rr == 0 and cc == 1) or (rr == (ROW + 1) and cc == COL)
            then
               if movable(rr, cc, d + 1) then
                  table.insert(queue, { rr, cc, d + 1 })
               end
            end
         end
      end
   end
end

local first_trip = move_around({ 0, 1 }, { ROW + 1, COL })
for _, b in pairs(blizzard) do
   b.r = (b.r + first_trip * moves[b.dir].dr - 1) % ROW + 1
   b.c = (b.c + first_trip * moves[b.dir].dc - 1) % COL + 1
end
local second_trip = move_around({ ROW + 1, COL }, { 0, 1 })
for _, b in pairs(blizzard) do
   b.r = (b.r + second_trip * moves[b.dir].dr - 1) % ROW + 1
   b.c = (b.c + second_trip * moves[b.dir].dc - 1) % COL + 1
end
local third_trip = move_around({ 0, 1 }, { ROW + 1, COL })

print("Part 1:", first_trip)
print("Part 2:", first_trip + second_trip + third_trip)
