{-# LANGUAGE DuplicateRecordFields, FlexibleInstances, UndecidableInstances #-}

module Grid where

import Control.Monad
import Data.Array
import Data.Bits
import Data.List
import Data.List.Split
--import Data.Set
--import Data.Text hiding (isPrefixOf, words)
import Debug.Trace
import System.Environment
import System.IO
import System.IO.Unsafe

import Data.List (isPrefixOf)

lineSearch _ [] _ = Nothing
lineSearch idx xs l = if isPrefixOf l xs then Just idx else lineSearch (idx+1) (Data.List.tail xs) l 
 
gridSearch (_, []) = undefined
gridSearch ([], _) = False  
gridSearch ((g:grid),(l:patern)) = case lineSearch 0 g l of 
    Just idx -> case investigateTail idx grid patern of 
      True -> True 
      False -> gridSearch (grid, (l:patern))
    Nothing -> gridSearch (grid,(l:patern))

lineSearch' :: Int -> [Int] -> String -> String -> [Int] 
lineSearch' _ f [] l = f 
lineSearch' idx found g@(x:gs) l = 
  if isPrefixOf l g then lineSearch' (idx+1) (idx:found) (tail g) l 
  else lineSearch' (idx+1) found (tail g) l

gridSearch' (_, []) = undefined
gridSearch' ([], _) = False  
gridSearch' ((g:grid),(l:patern)) = case lineSearch' 0 [] g l of 
    (x:xs) -> case foldr (||) False $ fmap (\idx ->investigateTail idx grid patern) (unsafePerformIO (print (x:xs) >> pure (x:xs))) of 
      True -> True 
      False -> gridSearch' (grid, (l:patern))
    [] -> gridSearch' (grid,(l:patern))


--investigateTail :: Int -> [[Int]] -> [[Int]] -> Bool
investigateTail _ _ [] = True 
investigateTail _ [] (p:ps) = False 
investigateTail idx (g:grid) (p:patern) = 
    isPrefixOf p (Data.List.drop idx g) && investigateTail idx grid patern

linesToCases :: [String] -> [([String], [String])]
linesToCases [] = []
linesToCases (l:lines) = 
   let 
     (len:_:[]) = words l 
     (grid, (info:rest)) = splitAt (read len) lines 
     (lenPat:_:[]) = words info
     (pat, rest') = splitAt (read lenPat) rest 
   in (grid, pat) : linesToCases rest' 

main :: Handle -> IO()
main hdl = do
    stin <- hGetContents hdl
    let (numInputs:liness) = lines stin
    --let lineCount:_:[] = words size 
    --let (grid, rest) = splitAt (read lineCount) liness
    let cases = linesToCases liness
    print cases
    mapM_ (\bool -> if bool then print YES else print NO) $ fmap gridSearch cases 
   
data YESNO = YES | NO deriving Show
