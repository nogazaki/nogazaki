local input = "input.txt"

local to_num = {
   ["A"] = 1, -- rock
   ["B"] = 2, -- paper
   ["C"] = 3, -- scissor
   ["X"] = 1, -- rock or lose
   ["Y"] = 2, -- paper or draw
   ["Z"] = 3, -- scissor or win
}
local function solution_1()
   local function round_score(them, me)
      local choice_score = me
      local outcome_score
      -- Draw
      if them == me then
         outcome_score = 3
         -- Win
      elseif (me - them) % 3 == 1 then
         outcome_score = 6
         -- Lose
      else
         outcome_score = 0
      end

      return choice_score + outcome_score
   end
   local score = 0

   for line in io.lines(input) do
      local them, me = line:match("([ABC])%s+([XYZ])")
      score = score + round_score(to_num[them], to_num[me])
   end

   return score
end
local function solution_2()
   local function round_score(them, outcome)
      local choice_score
      local outcome_score = (outcome - 1) * 3
      -- Draw
      if outcome == 2 then
         choice_score = them
         -- Win
      elseif outcome == 3 then
         choice_score = them % 3 + 1
         -- Lose
      else
         choice_score = (them + 1) % 3 + 1
      end

      return choice_score + outcome_score
   end
   local score = 0

   for line in io.lines(input) do
      local them, outcome = line:match("([ABC])%s+([XYZ])")
      score = score + round_score(to_num[them], to_num[outcome])
   end

   return score
end

print("Part 1:", solution_1())
print("Part 2:", solution_2())
