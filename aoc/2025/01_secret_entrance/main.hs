import System.IO

input = "input.txt"

parseLine :: String -> Int
parseLine str = read ((if head str == 'L' then '-' else ' ') : tail str)

solver :: (Int, Int, Int) -> (Int, Int, Int) -> (Int, Int, Int)
solver (pos, res1, res2) (move, _, _) = (nextPos, res1 + point, res2 + point + pass)
  where
    nextPosRaw = pos + move
    nextPos = mod nextPosRaw 100

    point = if nextPos == 0 then 1 else 0
    loop = max 0 (div (abs nextPosRaw) 100 - point)
    pass = loop + if pos * nextPosRaw < 0 then 1 else 0

main = do
  contents <- readFile input

  let moves = map parseLine (lines contents)
  let (_, ans1, ans2) = foldl solver (50, 0, 0) (map (,0,0) moves)

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
