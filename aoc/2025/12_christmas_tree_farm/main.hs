import Data.List.Split (splitOn)
import System.IO

-- This problem skips the hard part on the real input
-- and this solution is enough (won't work on the sample)
input = "input.txt"

parseShape :: String -> Int
parseShape str = length (filter (== '#') str)

parseGrid :: String -> (Int, [Int])
parseGrid str = (m * n, counts)
  where
    [m, n] = map read (splitOn "x" dimensions)
    counts = map read (splitOn " " shapeCounts)
    [dimensions, shapeCounts] = splitOn ": " str

main = do
  contents <- readFile input

  let sections = splitOn "\n\n" contents
  let shapeAreas = map parseShape (init sections)
  let grids = map parseGrid (lines (last sections))

  let ans1 = length (filter (\(a, c) -> a >= sum (zipWith (*) shapeAreas c)) grids)

  putStrLn ("Part 1: " ++ show ans1)
