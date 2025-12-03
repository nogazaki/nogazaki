import Data.Char (ord)
import Data.List (maximumBy)
import Data.Ord (comparing)
import System.IO

input = "input.txt"

solver :: Int -> Int -> [Int] -> Int
solver left right digits
  | right == 0 = digit
  | otherwise = digit * (10 ^ right) + value
  where
    (pos, digit) = maximumBy comparator (drop left (take right' (zip [1 ..] digits)))
    value = solver pos (right - 1) digits
    comparator = comparing snd <> flip (comparing fst)
    right' = length digits - right

main = do
  contents <- readFile input

  let digits = map (map (\a -> ord a - ord '0')) (lines contents)

  let ans1 = sum (map (solver 0 1) digits)
  let ans2 = sum (map (solver 0 11) digits)

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
