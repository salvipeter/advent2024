# Advent of Code 2024 Solutions

This time I decided to solve each day in a different programming language.

To make the challenge easier, I usually used AWK to convert the data files into
inline data in the day's language (I tried to be fair and only do trivial transformations).
After `make`-ing the project, you can run a specific day by `./run.sh` followed by the day's number.

Here's a table of the languages.

| Day | Language  | Implementation       | Notes                                     |
|-----|-----------|----------------------|-------------------------------------------|
| 1   | Uiua      | 0.14.0-dev.5         | Sort (⍆) was still experimental in 0.13.0 |
| 2   | Assembly  | NASM 2.16.03         | x86-64 Linux, uses only syscalls          |
| 3   | Smalltalk | GNU Smalltalk 3.2.92 | Reads the data by itself                  |
| 4   | BQN       | CBQN cf19280         | Don't ask me how it works...              |
