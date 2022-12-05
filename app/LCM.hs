{-# LANGUAGE FlexibleContexts #-}

module LCM where

-- Enter your code here. Read input from STDIN. Print output to STDOUT

import Text.Parsec
import Control.Monad
import Data.Either
import Control.Applicative hiding (optional, (<|>))
import GHC.IO.Handle
import System.IO

main = main' stdin


main' :: Handle -> IO ()
main' handle = do 
  len <- read <$> (hGetLine handle) :: IO Int
  print len
  arrStr <- hGetLine handle
  print arrStr
  numQs <- fmap read (hGetLine handle) :: IO Int
  print "three"
  queries <- replicateM numQs (getParseQuery handle)
  mapM_ print queries 
  print "four"

  --queries <- (fmap.fmap) (fromRight undefined) $ mapM (runParserT parseQuery () "") queryStrings
  arr0 <- runParserT parseArray () "" arrStr
  
  case arr0 of 
    Right arrInit -> recursePrintQueries arrInit queries 
    Left _ -> error "invalid input"
    
    
    
getParseQuery :: Handle -> IO Query
getParseQuery hdl = do 
   queryString <- hGetLine hdl
   let Right query = parse parseQuery "" queryString
   pure query   
  
  

recursePrintQueries :: [Int] -> [Query] -> IO ()
recursePrintQueries _ [] = pure ()
recursePrintQueries arrNow (q:qs) = case q of 
   U i mult -> do
     print arrNow 
     recursePrintQueries (performU (i, mult) arrNow) qs
   Q iStart iEnd -> do 
      -- drop then take diff
      let subA = take (iEnd - iStart + 1) $ drop iStart arrNow
      let lowestCommon = foldr lcm 1 subA
      print $ lowestCommon `rem` mm
      recursePrintQueries arrNow qs             
   

mm = 10^9+7

-- U mutates the valid input 
data Query = Q Int Int | U Int Int deriving Show 

-- (Idx, Multiplier) 
--
performU' :: (Int, Int) -> [Int] -> [Int]
performU' = undefined

performU :: (Int, Int) -> [Int] -> [Int]
performU (idx, mult) lis = 
   let 
     end' = drop idx lis
     multFirst (f:rest) = f * mult : rest
   in  
     take idx lis <> (multFirst end') 

parseArray :: Stream s m Char => ParsecT s u m [Int]
parseArray = do 
   asCharList <- some ((some digit) <* (optional (char ' ')))
   pure $ fmap (read :: String -> Int) $ asCharList 
   
parseQuery :: Stream s m Char => ParsecT s u m Query
parseQuery = do 
        trueIfQ <- (True <$ (char 'Q') <|> (False <$ (char 'U'))) <* space
        a <- some digit <* space 
        b <- some digit
        let a' = read a :: Int 
        let b' = read b :: Int
        pure $ if trueIfQ then Q a' b' else U a' b'        
