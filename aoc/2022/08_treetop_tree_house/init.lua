local M = require('solver'):new()

--------------------------------------------------

function M:score(r, c)
  local tree = self.forest[r][c]
  local tree_visibility = { true, true, true, true }
  local distance = { 0, 0, 0, 0 }

  for i = c - 1, 1, -1 do
    distance[1] = distance[1] + 1
    if self.forest[r][i] >= tree then
      tree_visibility[1] = false
      break
    end
  end

  for i = c + 1, #self.forest[1] do
    distance[2] = distance[2] + 1
    if self.forest[r][i] >= tree then
      tree_visibility[2] = false
      break
    end
  end

  for i = r - 1, 1, -1 do
    distance[3] = distance[3] + 1
    if self.forest[i][c] >= tree then
      tree_visibility[3] = false
      break
    end
  end

  for i = r + 1, #self.forest do
    distance[4] = distance[4] + 1
    if self.forest[i][c] >= tree then
      tree_visibility[4] = false
      break
    end
  end

  return tree_visibility[1] or tree_visibility[2] or tree_visibility[3] or tree_visibility[4],
    distance[1] * distance[2] * distance[3] * distance[4]
end

--------------------------------------------------

function M:parse_input(file)
  self.forest = {}
  for line in file:lines() do
    local row = {}
    for c in line:gmatch('.') do
      table.insert(row, tonumber(c))
    end

    table.insert(self.forest, row)
  end

  self.visible_count = 0
  self.scenic_score = 0
  for r = 1, #self.forest do
    for c = 1, #self.forest[1] do
      local visible, score = self:score(r, c)
      self.visible_count = self.visible_count + (visible and 1 or 0)
      self.scenic_score = math.max(self.scenic_score, score)
    end
  end
end

function M:part_1() return self.visible_count end

function M:part_2() return self.scenic_score end

--------------------------------------------------

return M
