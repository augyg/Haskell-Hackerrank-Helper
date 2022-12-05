module Main where

import qualified  LCM as LCM
import System.IO
import qualified Grid as Grid 

import qualified Data.IntMap as M

main :: IO ()
main = do
  fileHandle <- openFile "text-cases/input15.txt" ReadMode
  print "starting"
  Grid.main fileHandle

------------------
-- Scibbles


solve :: Int -> [Int] -> Int
solve k
  = bestChoice
  . count k
  . map (`mod` k)

bestChoice :: [Int] -> Int
bestChoice (x0 : xs) = (+ min 1 x0) . sum . selfZipWith max (min 1) $ xs
bestChoice [] = 0

count :: Int -> [Int] -> [Int]
count k xs =
  map (\i -> M.findWithDefault 0 i m) [0 .. (k-1)]
  where
    m = foldr (M.alter (Just . maybe 1 succ)) M.empty xs

selfZipWith :: (a -> a -> a) -> (a -> a) -> [a] -> [a]
selfZipWith f def xs = case splitAt h xs of
  (xs1, xs2) -> zipWith f xs1 (reverse (drop r xs2))
             ++ [def (head xs2) | r == 1]
  where
    (h, r) = length xs `divMod` 2







exclusivePermute xs =
  let
    xs' = zip [1..] xs
    f' orig (x:xs) = exclusivePermute' 0 x orig `max` (f' orig xs)
    exclusivePermute' n (idx,x') (x:xs) =
      if n == idx
      then exclusivePermute' (n+1) (idx,x) xs
      else (x,x') : exclusivePermute' (n+1) (idx,x) xs 

  in f' xs xs'





                              
