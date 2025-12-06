import Data.List (transpose)
import Data.List.Split (splitWhen)
import System.IO

input = "input.txt"

main = do
  contents <- readFile input

  let list = lines contents
  let ops = map (\a -> if a == '*' then (1, (*)) else (0, (+))) (filter (/= ' ') (last list))

  let n1 = map (map read . filter (not . null) . splitWhen (== ' ')) (init list)
  let numbers1 = transpose n1

  let n2 = [[x !! i | x <- init list] | i <- [0 .. length (head list) - 1]]
  let numbers2 = map (map read) (splitWhen (all (== ' ')) n2)

  let ans1 = sum (applyOps ops numbers1)
  let ans2 = sum (applyOps ops numbers2)

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
  where
    applyOps = zipWith (curry (\((init, op), num) -> foldl op init num))
