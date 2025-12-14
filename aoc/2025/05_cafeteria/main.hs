import Data.List (sort)
import Data.List.Split (splitOn)
import System.IO

input = "input.txt"

merge :: [[Int]] -> [(Int, Int)]
merge ([s1, e1] : [s2, e2] : rs)
  | e1 >= s2 = merge ([s1, max e1 e2] : rs)
merge ([s, e] : rs) = (s, e) : merge rs
merge [] = []

main = do
  contents <- readFile input

  let [db1, db2] = map lines (splitOn "\n\n" contents)

  let ranges = map (map read . splitOn "-") db1
  let available = map read db2

  let nonOverlap = merge (sort ranges)

  let ans1 = length [() | a <- available, (s, e) <- nonOverlap, s <= a && a <= e]
  let ans2 = sum (map (\(a, b) -> b - a + 1) nonOverlap)

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
