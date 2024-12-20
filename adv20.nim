const
  height = data.len
  width = data[0].len

type Pos = (int, int)

func search(c: char): Pos =
  for i in 0..<height:
    for j in 0..<width:
      if data[i][j] == c:
         return (j, i)

let
  p0 = search 'S'
  p1 = search 'E'

proc step(pos: Pos, last: Pos): Pos =
  let (x, y) = pos
  for p in [(x+1,y),(x-1,y),(x,y+1),(x,y-1)]:
    if data[p[1]][p[0]] != '#' and p != last:
      return p

var
  path = newSeq[Pos]()
  p = p0
  last = p
path.add p
while p != p1:
  (p, last) = (step(p, last), p)
  path.add p

func dist(p1: Pos, p2: Pos): int =
  abs(p1[0] - p2[0]) + abs(p1[1] - p2[1])

proc count(maxcheat: int, minsave: int): int =
  for i in 0..<path.len:
    for j in i+1..<path.len:
      let d = dist(path[i], path[j])
      if d <= maxcheat:
        let saved = j - i - d
        if saved >= minsave:
          result += 1

echo count(2, 100)
echo count(20, 100)
