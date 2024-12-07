-module(adv07).
-export([main/1]).

check(_, Y, [Y]) -> true;
check(_, _, [_]) -> false;
check(Part2, Y, [X|Xs]) ->
    X > 0 andalso Y rem X == 0 andalso check(Part2, Y div X, Xs) orelse
        Y > X andalso check(Part2, Y - X, Xs) orelse
        Part2 andalso endsWith(Y, X) andalso check(Part2, shiftWith(Y, X), Xs).

endsWith(A, B) -> lists:suffix(integer_to_list(B), integer_to_list(A)).

shiftWith(A, A) -> 0;
shiftWith(A, B) ->
    As = integer_to_list(A),
    Bs = integer_to_list(B),
    {X,_} = lists:split(length(As) - length(Bs), As),
    list_to_integer(X).

solve(Part2) ->
    F = fun({Y,Xs}) -> check(Part2, Y, lists:reverse(Xs)) andalso {true, Y} end,
    lists:sum(lists:filtermap(F, data())).

main(_) ->
    io:format("~p~n~p~n", [solve(false),solve(true)]).
