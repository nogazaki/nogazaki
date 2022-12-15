local input = 'input.txt'

local row = input:match("%d") and 10 or 2000000
local limit = input:match("%d") and 20 or 4000000

local function manhattan(p1, p2)
   return math.abs(p1.x - p2.x) + math.abs(p1.y - p2.y)
end
local sort_func = function(a, b) return a[1] < b[1] end
local function merge_intervals(intervals)
   table.sort(intervals, sort_func)
   local sorted = { intervals[1] }

   for i = 2, #intervals do
      local last, interval = sorted[#sorted], intervals[i]
      if last[1] <= interval[1] and interval[1] <= last[2] then
         last[2] = math.max(last[2], interval[2])
      else
         table.insert(sorted, interval)
      end
   end

   return sorted
end

local total = 0

local sections = {}
local sensors, beacons = {}, {}
local coefficients = { [1] = {}, [-1] = {} }
for line in io.lines(input) do
   local sensor, beacon = {}, {}
   sensor.x, sensor.y, beacon.x, beacon.y = line:match(string.rep("(%-?%d+).-", 4))

   if beacon.y - row == 0 and not beacons[beacon.x] then
      beacons[beacon.x] = true; total = total - 1
   end

   local d = manhattan(sensor, beacon)
   local dy = math.abs(sensor.y - row)

   if dy <= d then table.insert(sections, { sensor.x - d + dy, sensor.x + d - dy }) end

   table.insert(sensors, { pos = sensor, r = d })
   coefficients[1][sensor.y - sensor.x + d + 1] = true
   coefficients[1][sensor.y - sensor.x - d - 1] = true
   coefficients[-1][sensor.y + sensor.x + d + 1] = true
   coefficients[-1][sensor.y + sensor.x - d - 1] = true
end

sections = merge_intervals(sections)
for _, section in pairs(sections) do
   total = total + (section[2] - section[1] + 1)
end

local freq
for a in pairs(coefficients[1]) do
   for b in pairs(coefficients[-1]) do
      local intersect = { x = math.floor((b - a) / 2), y = math.floor((b + a) / 2) }
      if 0 <= intersect.x and intersect.x <= limit and
          0 <= intersect.y and intersect.y <= limit
      then
         local all = true
         for _, sensor in pairs(sensors) do
            all = manhattan(sensor.pos, intersect) > sensor.r
            if not all then break end
         end
         freq = all and (4000000 * intersect.x + intersect.y) or nil
      end
      if freq then break end
   end
   if freq then break end
end

print("Part 1:", total)
print("Part 2:", freq)
