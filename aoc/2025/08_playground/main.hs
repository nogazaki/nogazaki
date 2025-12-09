import Data.List (sort, sortBy)
import Data.List.Split (splitOn)
import Data.Ord (Down (Down), comparing)
import System.IO

(input, count) = ("input.txt", 1000)

connect :: [(Int, Int)] -> (Int, Int) -> [(Int, Int)]
connect graph (a, b) = map nextAt [0 .. length graph - 1]
  where
    (a', countA) = findRoot a
    (b', countB) = findRoot b
    root = min a' b'
    count = countA + if a' == b' then 0 else countB
    nextAt index
      | index == root = (root, count)
      | index `elem` [a, b, a', b'] = (root, -1)
      | otherwise = graph !! index
    findRoot index
      | index == index' = node
      | otherwise = findRoot index'
      where
        node@(index', _) = graph !! index

allConnectedPoint :: [(Int, Int)] -> [(Int, Int)] -> (Int, Int)
allConnectedPoint graph (p : ps)
  | maximum (map snd nextGraph) == length graph = p
  | otherwise = allConnectedPoint nextGraph ps
  where
    nextGraph = connect graph p

main = do
  contents <- readFile input

  let grid = map (map read . splitOn ",") (lines contents) :: [[Int]]

  let distances = concat [[(euclidean a b, ai, bi) | (bi, b) <- drop (ai + 1) (zip [0 ..] grid)] | (ai, a) <- zip [0 ..] grid]
  let pairs = map (\(_, a, b) -> (a, b)) (sort distances)

  let graph = foldl connect (take (length grid) (map (,1) [0 ..])) (take count pairs)
  let (a, b) = allConnectedPoint graph (drop count pairs)

  let ans1 = product (take 3 (sortBy (comparing Down) (map snd graph)))
  let ans2 = head (grid !! a) * head (grid !! b)

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
  where
    euclidean a b = sum (map (^ 2) (zipWith (-) a b))
