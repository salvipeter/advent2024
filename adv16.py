import heapq as pq

height = len(data)
width = len(data[0])

# Find start/end position
for i in range(height):
    for j in range(width):
        if data[i][j] == 'S':
            start = (j, i)
        if data[i][j] == 'E':
            end = (j, i)

def step(pos):
    (x, y, d) = pos
    match d:
        case 0: return (x, y - 1, d)
        case 1: return (x + 1, y, d)
        case 2: return (x, y + 1, d)
        case 3: return (x - 1, y, d)

def valid(pos):
    (x, y, _) = pos
    return x >= 0 and x < width and y >= 0 and y < height and data[y][x] != '#'

def turn(pos, dd):
    (x, y, d) = pos
    return (x, y, (d + dd + 4) % 4)

def adjacent(pos):
    result = [(1000, turn(pos, 1)), (1000, turn(pos, -1))]
    pos1 = step(pos)
    if valid(pos1):
        result.append((1, pos1))
    return result

def shortest(source):
    queue = [(0, source)]
    pq.heapify(queue)
    result = { source: 0 }
    while queue:
        (cost, pos) = pq.heappop(queue)
        for (dc, p) in adjacent(pos):
            if p not in result or cost + dc < result[p]:
                result[p] = cost + dc
                pq.heappush(queue, (cost + dc, p))
    return result

p1 = shortest((start[0], start[1], 1))
best = min([p1[end[0],end[1],d] for d in range(4)])
print(best)

p2 = [shortest((end[0], end[1], d)) for d in range(4)]
count = 0
for i in range(height):
    for j in range(width):
        if data[i][j] != '#':
            for k in range(4):
                c1 = p1[j,i,k]
                c2 = min([p2[d][turn((j, i, k), 2)] for d in range(4)])
                if c1 + c2 == best:
                    count += 1
                    break
print(count)
