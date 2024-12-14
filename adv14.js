show = false;
width = 101;
height = 103;

function step(robot, n) {
    x = ((robot.p[0] + robot.v[0] * n) % width + width) % width;
    y = ((robot.p[1] + robot.v[1] * n) % height + height) % height;
    return [x, y];
}

quads = [0,0,0,0];
data.forEach(robot => {
    [x, y] = step(robot, 100);
    if (x * 2 < width - 1 && y * 2 < height - 1) quads[0]++;
    if (x * 2 > width - 1 && y * 2 < height - 1) quads[1]++;
    if (x * 2 < width - 1 && y * 2 > height - 1) quads[2]++;
    if (x * 2 > width - 1 && y * 2 > height - 1) quads[3]++;
});
console.log(quads.reduce((a, b) => a * b, 1));

// The cycle of each robot is 101 * 103 = 10403
// So just let us look at all that...
for (let i = 0; i < 101 * 103; ++i) {
    let floor = Array.from({ length: width }, () => new Array(height).fill(0));
    data.forEach(robot => {
        [x, y] = step(robot, i);
        floor[x][y]++;
    });
    // Find the time when there are at least 10 consecutive robots
    let found = false;
    for (let y = 0; y < height && !found; ++y) {
        let n = 0;
        for (let x = 0; x < width; ++x)
            if (floor[x][y] > 0) {
                n++;
                if (n == 10) {
                    found = true;
                    break;
                }
            } else
                n = 0;
    }
    if (found) {
        console.log(i);
        if (show) {
            for (y = 0; y < height; ++y) {
                s = "";
                for (x = 0; x < width; ++x) {
                    s += floor[x][y];
                }
                console.log(s);
            }
        }
    }
}
