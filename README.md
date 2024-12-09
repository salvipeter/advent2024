# Advent of Code 2024 Solutions

This time I decided to solve each day in a different programming language.

To make the challenge easier, I usually used AWK to convert the data files into
inline data in the day's language (I tried to be fair and only do trivial transformations).
After `make`-ing the project, you can run a specific day by `./run.sh` followed by the day's number.

Here's a table of the languages.

| Day | Language  | Implementation       | Notes                                              |
|-----|-----------|----------------------|----------------------------------------------------|
| 1   | Uiua      | 0.14.0-dev.5         | Sort (⍆) was still experimental in 0.13.0          |
| 2   | Assembly  | NASM 2.16.03         | x86-64 Linux, uses only syscalls                   |
| 3   | Smalltalk | GNU Smalltalk 3.2.92 | Reads the data by itself                           |
| 4   | BQN       | CBQN cf19280         |                                                    |
| 5   | Forth     | Gforth 0.7.9         | Uses only the core and core extension wordsets [1] |
| 6   | Haskell   | GHC 9.4.8            |                                                    |
| 7   | Erlang    | Erlang/OTP 27.1.2    |                                                    |
| 8   | PicoLisp  | PicoLisp 18.9.5      |                                                    |
| 9   | FORTRAN   | GNU Fortran 14.2.1   | Needs 8-byte integers (-fdefault-integer-8)        |

[1] So it can also be run by my [Core Forth implementation](https://github.com/salvipeter/core-forth/)
