fn combo(n: u8, a: u64, b: u64, c: u64) -> u64 {
    match n {
        0 | 1 | 2 | 3 => n as u64,
        4 => a,
        5 => b,
        6 => c,
        _ => unreachable!()
    }
}

fn run(xs: &[u8], mut a: u64, mut b: u64, mut c: u64) -> Vec<u8> {
    let mut result = vec![];
    let mut ip: usize = 0;
    while ip < xs.len() {
        let mut jump: bool = false;
        match xs[ip] {
            0 => /* adv */ a >>= combo(xs[ip+1], a, b, c),
            1 => /* bxl */ b ^= xs[ip+1] as u64,
            2 => /* bst */ b = combo(xs[ip+1], a, b, c) & 7,
            3 => /* jnz */ if a != 0 { ip = xs[ip+1] as usize; jump = true }
            4 => /* bxc */ b ^= c,
            5 => /* out */ result.push((b & 7) as u8),
            6 => /* bdv */ b = a >> combo(xs[ip+1], a, b, c),
            7 => /* cdv */ c = a >> combo(xs[ip+1], a, b, c),
            _ => unreachable!()
        }
        if !jump {
            ip += 2;
        }
    }
    return result;
}

fn display(xs: &[u8]) {
    print!("{}", xs[0]);
    for i in 1..xs.len() {
        print!(",{}", xs[i]);
    }
    println!("");
}

fn main() {
    display(&run(&PROGRAM, A, B, C));
    // Looking at the program, we know that:
    // - the value is in the interval [8^15, 8^16)
    // - the i-th output is based on the i-th octal digit of A (counted from the end)
    // We can try to set one digit a time, but for efficiency,
    // we should start from the last digits as these result in larger jumps in A.
    let mut a: u64 = 1 << 45;
    loop {
        let xs = run(&PROGRAM, a, B, C);
        if xs == PROGRAM {
            break;
        }
        for i in (0..16).rev() {
            if xs[i] != PROGRAM[i] {
                a += 1 << i * 3;
                break;
            }
        }
    }
    println!("{}", a);
}
