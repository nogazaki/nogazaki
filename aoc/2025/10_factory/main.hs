import Data.List (subsequences)
import Data.List.Split (splitOn)
import System.IO
import Text.Regex.PCRE

input = "input.txt"

parseLine :: String -> ([Int], [[Int]], [Int])
parseLine str = (target, buttons, joltage)
  where
    target = [if a == '#' then 1 else 0 | a <- targetStr]
    buttons = map toggle buttonIndexes
    joltage = map read (splitOn "," joltageStr)

    buttonIndexes = map (map read . splitOn "," . init . tail) (splitOn " " buttonStr)

    [_, targetStr, buttonStr, joltageStr] = head match
    format = "\\[(.+?)\\] (\\(.+?\\)) \\{(.+?)\\}"
    match = str =~ format :: [[String]]

    toggle b = [if i `elem` b then 1 else 0 | (i, _) <- zip [0 ..] target]

matchParity :: [Int] -> [[Int]] -> [([Int], Int)]
matchParity target buttons = filter ((== parity target) . parity . fst) states
  where
    states = map (\c -> (pressAll c, length c)) (subsequences buttons)
    pressAll = foldl (zipWith (+)) (replicate (length target) 0)
    parity = map (`mod` 2)

matchJoltage :: [Int] -> [[Int]] -> Int
matchJoltage target buttons
  | all (== 0) target = 0
  | any (< 0) target = 10 ^ 10
  | null nextTargets = 10 ^ 10
  | otherwise = minimum [2 * matchJoltage a buttons + b | (a, b) <- nextTargets]
  where
    nextTargets = [(map (`div` 2) (zipWith (-) target ns), c) | (ns, c) <- matchParity target buttons]

main = do
  contents <- readFile input

  let machines = map parseLine (lines contents)

  let ans1 = sum [(minimum . map snd) (matchParity t b) | (t, b, _) <- machines]
  let ans2 = sum [matchJoltage j b | (_, b, j) <- machines]

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
