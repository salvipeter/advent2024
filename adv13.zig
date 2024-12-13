const std = @import("std");

const Vec = struct { x: i64, y: i64 };
const Machine = struct { a: Vec, b: Vec, p: Vec };

const data = [_]Machine{
    // DATA PLACEHOLDER
};

fn tokens(extra: i64) i64 {
    var sum: i64 = 0;
    for (data) |m| {
        const px, const py = .{ m.p.x + extra, m.p.y + extra };
        const d = m.a.x * m.b.y - m.a.y * m.b.x;
        std.debug.assert(d != 0); // parallel vectors would require special handling
        const a = m.b.y * px - m.b.x * py;
        const b = m.a.x * py - m.a.y * px;
        if (@mod(a, d) == 0 and @mod(b, d) == 0)
            sum += @divExact(a, d) * 3 + @divExact(b, d);
    }
    return sum;
}

pub fn main() void {
    std.debug.print("{d}\n{d}\n", .{ tokens(0), tokens(10000000000000) });
}
