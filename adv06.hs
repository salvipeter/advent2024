import Data.List
import Data.Maybe

data Dir = U | R | D | L deriving Eq

x = fromJust $ elemIndex '^' (d !! y)
y = fromJust $ findIndex (elem '^') d
width = length (head d)
height = length d

path pos dir | outside pos = []
             | blocked pos = path (step pos (back dir)) (turn dir)
             | otherwise   = pos : path (step pos dir) dir

loops pos dir acc obt
    | outside pos               = False
    | elem (pos,dir) acc        = True
    | pos == obt || blocked pos = loops (step pos (back dir)) (turn dir) (tail acc) obt
    | otherwise                 = loops (step pos dir) dir ((pos,dir) : acc) obt

outside (x,y) = x < 0 || y < 0 || x >= width || y >= height

blocked (x,y) = d !! y !! x == '#'

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
          obtrusions  = length $ filter (loops (x,y) U []) candidates
          candidates  = [pos | pos <- visited, pos /= (x,y)]
