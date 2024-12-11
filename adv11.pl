solve :-
    data(L), all_stones(25, L, P1), all_stones(75, L, P2),
    write(P1), nl, write(P2), nl.

all_stones(N, L, X) :- maplist(stone(N), L, Xs), sumlist(Xs, X).

:- table(stone/3).
stone(0, _, 1) :- !.
stone(K, 0, X) :- !, K > 0, K1 is K - 1, stone(K1, 1, X).
stone(K, N, X) :-
    K > 0, K1 is K - 1,
    halves(N, L, R), !, stone(K1, L, X1), stone(K1, R, X2),
    X is X1 + X2.
stone(K, N, X) :- K > 0, K1 is K - 1, N1 is N * 2024, stone(K1, N1, X).

halves(N, L, R) :-
    digits(N, D), length(D, ND), ND mod 2 =:= 0, K is ND // 2,
    take(D, K, Ls, Rs), build(Ls, L), build(Rs, R).

take(Xs, 0, [], Xs) :- !.
take([X|Xs], K, [X|L], R) :- K > 0, K1 is K - 1, take(Xs, K1, L, R).

% Both build/2 and digits/2 are simpler when digits are reversed

build([X], X) :- !.
build([X|Xs], N) :- build(Xs, N0), N is N0 * 10 + X.

digits(N, [N]) :- N < 10, !.
digits(N, [D|L]) :-
    N >= 10,
    D is N mod 10, N1 is N // 10,
    digits(N1, L).

