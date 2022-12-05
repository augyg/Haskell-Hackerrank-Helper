import Control.Monad
import Control.Monad.State

-- import Text.Show.Pretty (ppShow)
-- pprint x = putStrLn $ ppShow x

data SegTree = NULL
             | SegTree { li :: Int -- left bound
                       , ri :: Int -- right bound
                       , val :: Integer -- val, which is lcm of bucket (Bucket is either some range or a single number) 
                       , left :: SegTree
                       , right :: SegTree
                       }
  deriving Show

mm = 10^9+7
-- lcm' a b = (lcm a b) `rem` mm

-- l seems to be the starting point ?
-- r seems to be the end index?
build :: Int -> Int -> [Integer] -> SegTree
build l r ns =
  let midpoint = (l + r) `div` 2
      (lns, rns) = splitAt (midpoint - l + 1) ns
      lt = if l == r then NULL else build l     midpoint lns
      rt = if l == r then NULL else build (m+1) r        rns
      v =  if l == r then head ns else lcm (val lt) (val rt) -- Val seems to be either the idx itself or an lcm of the idxs in its Left and Right forks 
  in  SegTree l r v lt rt

query :: SegTree -> Int -> Int -> Integer
query NULL _ _ = error "bad weather"
query (SegTree l r v lt rt) i j
  | i == l && j == r = v
  | j <= m = query lt i j
  | m < i = query rt i j
  | otherwise = lcm (query lt i m) (query rt (m+1) j)
  where
    m = (l + r) `div` 2




update :: SegTree -> Int -> Int -> SegTree
update (SegTree l r v lt rt) i x =
  let m = (l + r) `div` 2
      lt' = if i <= m then update lt i x else lt
      rt' = if m < i  then update rt i x else rt
  in  if l == r
        then SegTree l r (v * fromIntegral x) NULL NULL
        else SegTree l r (lcm (val lt') (val rt')) lt' rt'


swap :: [String] -> StateT SegTree IO ()
swap [] = return ()
swap (s:ss) = do
  tree <- get
  if tp == "Q"
     then liftIO . print . (`rem` mm) $ query tree i' j'
     else do put $ update tree i' j'
             -- liftIO . pprint =<< get
  -- tree' <- get
-- liftIO . print $ query tree' 3 4
  swap ss
    where [tp, i, j] = words s
          i' = read i
          j' = read j

main :: IO ()
main = do
  lengthOfArr <- readLn :: IO Int
  arr0 <- return . map read . words =<< getLine
  let tree = build 0 (lengthOfArr-1) arr0
  q <- readLn :: IO Int
  qs <- replicateM q getLine
  runStateT (swap qs) tree
  return ()
