import System.IO

input = "input.txt"

remove :: [[Int]] -> [[Int]]
remove grid = [[if at r c == 0 then 0 else next r c | c <- [0 .. cols]] | r <- [0 .. rows]]
  where
    rows = length grid - 1
    cols = length (head grid) - 1
    at r c = (grid !! r) !! c
    inBound r c = r >= 0 && r <= rows && c >= 0 && c <= cols
    neighbors r c = [at r' c' | r' <- map (r +) [-1 .. 1], c' <- map (c +) [-1 .. 1], inBound r' c']
    next r c = if sum (neighbors r c) <= 4 then 0 else 1

solver :: [[Int]] -> [Int]
solver grid
  | diff == 0 = []
  | otherwise = diff : solver next
  where
    count g = sum (concat g)
    next = remove grid
    diff = count grid - count next

main = do
  contents <- readFile input

  let grid = map (map (\a -> if a == '@' then 1 else 0)) (lines contents)
  let diffs = solver grid

  let ans1 = head diffs
  let ans2 = sum diffs

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
