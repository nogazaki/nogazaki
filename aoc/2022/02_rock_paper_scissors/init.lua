local M = require('solver'):new()

--------------------------------------------------

local function scoring_1(a, b)
  local choice_score = b
  local outcome_score = (b - a + 1) % 3 * 3

  return outcome_score + choice_score
end

local function scoring_2(a, b)
  local choice_score = (a + b) % 3 + 1
  local outcome_score = (b - 1) * 3

  return outcome_score + choice_score
end

--------------------------------------------------

function M:parse_input(file)
  local SCORES = { A = 1, B = 2, C = 3, X = 1, Y = 2, Z = 3 }

  self.scores_1 = 0
  self.scores_2 = 0

  for line in file:lines() do
    local a, b = line:match('([ABC])%s+([XYZ])')
    a, b = SCORES[a], SCORES[b]

    self.scores_1 = self.scores_1 + scoring_1(a, b)
    self.scores_2 = self.scores_2 + scoring_2(a, b)
  end
end

function M:part_1() return self.scores_1 end

function M:part_2() return self.scores_2 end

--------------------------------------------------

return M
