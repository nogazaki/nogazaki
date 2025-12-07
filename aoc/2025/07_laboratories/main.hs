import System.IO

input = "input.txt"

solver :: Int -> [String] -> [Int] -> (Int, Int)
solver ri grid beams
  | ri < length grid = (length splits + splitted, total)
  | otherwise = (0, sum beams)
  where
    (splitted, total) = solver (ri + 1) grid nextBeams
    splits = [ci | (ci, (b, c)) <- zip [0 ..] (zip beams (grid !! ri)), b > 0, c == '^']
    nextBeams = [combine ci | ci <- [0 .. length beams - 1]]
    combine ci = left + center + right
      where
        center = if ci `elem` splits then 0 else beams !! ci
        [left, right] = map (\a -> if a `elem` splits then beams !! a else 0) [ci - 1, ci + 1]

main = do
  contents <- readFile input

  let grid = lines contents

  let beams = map (\a -> if a == 'S' then 1 else 0) (head grid)
  let (ans1, ans2) = solver 1 grid beams

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
