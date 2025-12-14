import Data.List.Split (splitOn)
import System.IO

input = "input.txt"

main = do
  contents <- readFile input

  let coords = map (map read . splitOn ",") (lines contents)
  let edges = zip coords (last coords : init coords)

  let areas = concat [[(area a b, contained a b edges) | b <- drop (ai + 1) coords] | (ai, a) <- zip [0 ..] coords]

  let (ans1, _) = maximum areas
  let (ans2, _) = maximum (filter snd areas)

  putStrLn ("Part 1: " ++ show ans1)
  putStrLn ("Part 2: " ++ show ans2)
  where
    area a b = product (map ((+ 1) . abs) (zipWith (-) a b))
    contained a b = all (nonIntersect (a, b))
    nonIntersect (a, b) ([px, py], [qx, qy])
      | py == qy = py >= ymax || py <= ymin || (px <= xmin && qx <= xmin) || (px >= xmax && qx >= xmax)
      | otherwise = px >= xmax || px <= xmin || (py <= ymin && qy <= ymin) || (py >= ymax && qy >= ymax)
      where
        [xmin, ymin] = zipWith min a b
        [xmax, ymax] = zipWith max a b
