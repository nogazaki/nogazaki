import Data.List (nub)
import Data.List.Split (splitOn)
import System.IO

input = "input.txt"

getMultipliers1 :: Int -> [(Int, Int, Int)]
getMultipliers1 x
  | even x = [(10 ^ (div x 2 - 1), 10 ^ div x 2 - 1, 10 ^ div x 2 + 1)]
  | otherwise = []

getMultipliers2 :: Int -> [(Int, Int, Int)]
getMultipliers2 1 = []
getMultipliers2 x = (1, 9, div (10 ^ x - 1) 9) : map f factors
  where
    factors = filter (\a -> mod x a == 0) [2 .. x - 1]
    f a = (10 ^ (a - 1), 10 ^ a - 1, sum (map (10 ^) (take (div x a) [0, a ..])))

solver :: (Int -> [(Int, Int, Int)]) -> String -> [Int]
solver getter str = nub res
  where
    [(start, sLen), (end, eLen)] = map (\a -> (read a, length a)) (splitOn "-" str)
    multipliers = concatMap getter [sLen .. eLen]
    ranges = [(max x (ceil' start z), min y (floor' end z), z) | (x, y, z) <- multipliers]
    res = [a * z | (x, y, z) <- ranges, a <- [x .. y]]
    ceil' a b = div a b + if mod a b == 0 then 0 else 1
    floor' = div

main = do
  contents <- readFile input

  let list = splitOn "," (init contents)

  let ans1 = sum (concatMap (solver getMultipliers1) list)
  let ans2 = sum (concatMap (solver getMultipliers2) list)

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
