module Main where

import qualified  LCM as LCM
import System.IO


main :: IO ()
main = do
  fileHandle <- openFile "text-cases/input02.txt" ReadMode 
  LCM.main' fileHandle

