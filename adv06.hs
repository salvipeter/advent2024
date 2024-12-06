import Data.Array (listArray, (!))
import Data.List (elemIndex, filter, findIndex, nub)
import Data.Maybe (fromJust, maybe)

data Dir = U | R | D | L deriving Eq

x = fromJust $ elemIndex '^' (d !! y)
y = fromJust $ findIndex (elem '^') d
width = length (head d)
height = length d

path pos dir | outside pos = []
             | blocked pos = path (step pos (back dir)) (turn dir)
             | otherwise   = pos : path (step pos dir) dir

-- Optimization: remembers only the path _after_ the obtrusion,
--               and only those points where the guard turns.
-- (Interestingly, using a Set for acc would make it slower.)
loops pos dir acc obt
    | outside next = False
    | next == obt  = loops pos (turn dir) (maybe (Just []) Just acc) obt
    | blocked next = loops pos (turn dir) (fmap ((pos,dir) :) acc) obt
    | visited      = True
    | otherwise    = loops next dir acc obt
    where next     = step pos dir
          visited  = maybe False (elem (next,dir)) acc

outside (x,y) = x < 0 || y < 0 || x >= width || y >= height

-- Another optimization: blocked uses an array for O(1) indexing
mapArray = listArray ((0,0),(height-1,width-1)) $ concat d

blocked (x,y) = mapArray ! (y,x) == '#'

step (x,y) U = (x,y-1)
step (x,y) R = (x+1,y)
step (x,y) D = (x,y+1)
step (x,y) L = (x-1,y)

back = turn . turn

turn U = R
turn R = D
turn D = L
turn L = U

main = putStrLn (show $ length visited) >> putStrLn (show obtrusions)
    where visited     = nub $ path (x,y) U
          obtrusions  = length $ filter (loops (x,y) U Nothing) candidates
          candidates  = [pos | pos <- visited, pos /= (x,y)]
