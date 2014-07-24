-module(powers).
-export([raise/2, nth_root/2]).

-spec(raise(number(), number()) -> number()).
-spec(nth_root(number(), number()) -> number()).


raise(X, N) ->
	if
		N == 0 -> 1;
		N == 1 -> X;
		N > 1 -> raise(X, N, 1);
		N < 0 -> 1.0/raise(X, -N)
	end.


raise(X, N, Accumulator) ->
	if
		N == 0 -> Accumulator;
		N > 0 -> raise(X, N - 1, X * Accumulator)
	end.

absolute_value(X) ->
	if
		X >= 0 -> X;
		X < 0 -> -X
	end.

nth_root(X, N, A) -> 
	io:format("current guess is ~w \n", [A]),
	F = raise(A, N) - X,
	Fprime = N * raise(A, N - 1.0),
	Next = A - F/Fprime,
	Change = absolute_value(Next - A),
	%%io:format("current change is ~w \n", [Change]),

	if
		Change < 0.00000001 -> Next;
		Change >= 0.00000001 -> nth_root(X, N, Next)

	end.

nth_root(X, N) -> nth_root(X, N, X / 2.0).
