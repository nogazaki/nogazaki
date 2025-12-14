import Data.Map qualified as Map
import Data.Maybe (fromMaybe)
import System.IO

input = "input.txt"

parseLine :: String -> (String, [String])
parseLine "" = ([], [])
parseLine (' ' : m1 : m2 : m3 : others) = ([], [m1, m2, m3] : snd (parseLine others))
parseLine (m1 : m2 : m3 : ':' : others) = ([m1, m2, m3], snd (parseLine others))

countPaths :: Map.Map String [String] -> [(String, Int)] -> String -> Int
countPaths _ [] _ = 0
countPaths machines origins dest = count + nextCount
  where
    mapOrigin (m, count) = maybe [] (map (,count)) (Map.lookup m machines)
    nextOrigins = Map.fromListWith (+) (concatMap mapOrigin origins)
    count = fromMaybe 0 (Map.lookup dest nextOrigins)
    nextCount = countPaths machines (Map.toList nextOrigins) dest

main = do
  contents <- readFile input

  let machines = Map.fromList (map parseLine (lines contents))

  let count a = countPaths machines [(a, 1)]

  let ans1 = count "you" "out"

  let p1 = count "svr" "fft" * count "fft" "dac" * count "dac" "out"
  let p2 = count "svr" "dac" * count "dac" "fft" * count "fft" "out"
  let ans2 = p1 + p2

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
