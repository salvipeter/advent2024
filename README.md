# Advent of Code 2024 Solutions

This time I decided to solve each day in a different programming language.

To make the challenge easier, I used AWK to convert the data files into
inline data in the day's language (I tried to be fair and do only trivial transformations).
After `make`-ing the project, you can run a specific day by `./run.sh` followed by the day's number.

Here's a table of the languages.
I always selected the language *before* looking at the problem,
the only exception being Day 11, which I planned to do in Perl,
but ended up solving it in Prolog (tabling seemed such a good match for the task).

| Day | Language    | Implementation       | Notes                                               |
|-----|-------------|----------------------|-----------------------------------------------------|
| 1   | Uiua        | uiua 0.14.0-dev.5    | Sort (⍆) was still experimental in 0.13.0           |
| 2   | Assembly    | NASM 2.16.03         | x86-64 Linux, uses only syscalls                    |
| 3   | Smalltalk   | GNU Smalltalk 3.2.92 | Reads the data by itself                            |
| 4   | BQN         | CBQN cf19280         |                                                     |
| 5   | Forth       | Gforth 0.7.9         | Uses only the core and core extension wordsets [1]  |
| 6   | Haskell     | GHC 9.4.8            |                                                     |
| 7   | Erlang      | Erlang/OTP 27.1.2    |                                                     |
| 8   | PicoLisp    | PicoLisp 18.9.5      |                                                     |
| 9   | FORTRAN     | GNU Fortran 14.2.1   | Needs 8-byte integers (-fdefault-integer-8)         |
| 10  | Go          | go 1.23.4            |                                                     |
| 11  | Prolog      | SWI-Prolog 9.2.7     | Originally planned to do it in Perl                 |
| 12  | Perl        | perl 5.40.0          | Command line argument indicates Part 1 or 2         |
| 13  | Zig         | Zig 0.13.0           | Literal array of structs created by AWK             |
| 14  | JavaScript  | Node.js 23.1.0       | The `show` variable controls image display          |
| 15  | C           | gcc 14.2.1           | Command line argument animates Part 1 or 2          |
| 16  | Python      | Python 3.12.7        |                                                     |
| 17  | Rust        | rustc 1.83.0         |                                                     |
| 18  | Standard ML | Poly/ML 5.9.1        | Part 2 simple but slow (still below 1m [2])         |
| 19  | Tcl         | Tcl 8.6.14-4         |                                                     |
| 20  | Nim         | Nim 2.2.0            |                                                     |
| 21  | Scheme      | Gambit 4.9.4         | Works also with Chez, CHICKEN, Gauche & Guile       |
| 22  | OCaml       | OCaml 5.2.0          |                                                     |
| 23  | Common Lisp | SBCL 2.4.9           |                                                     |
| 24  | Julia       | Julia 1.11.2         | Probably not completely general (originally manual) |
| 25  | C++         | g++ 14.2.1           |                                                     |

[1] So it can also be run by my [Core Forth implementation](https://github.com/salvipeter/core-forth/)

[2] ~30s with MLton 20210117, but ~1.5m with SML/NJ 110.99.6.1
