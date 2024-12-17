fn run(mut a: u64) -> Vec<u8> {
    let mut result = vec![];
    while a != 0 {
        let b = a & 7 ^ 2;
        result.push(((b ^ a >> b ^ 3) & 7) as u8);
        a >>= 3;
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
    display(&run(35200350));
    let program: Vec<u8> = vec![2,4,1,2,7,5,4,7,1,3,5,5,0,3,3,0];
    // Looking at the program, we know that:
    // - the value is in the interval [8^15, 8^16)
    // - the i-th output is based on the i-th octal digit of A (counted from the end)
    // We can try to set one digit a time, but for efficiency,
    // we should start from the last digits as these result in larger jumps in A.
    let mut a: u64 = 1 << 45;
    loop {
        let xs = run(a);
        if xs == program {
            break;
        }
        for i in (0..16).rev() {
            if xs[i] != program[i] {
                a += 1 << i * 3;
                break;
            }
        }
    }
    println!("{}", a);
}
