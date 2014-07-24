-module(dijkstra).
-export([gcd/2]).

-spec(gcd(number(), number()) -> number()).

gcd(M, N) when M >=0, N >=0 ->
	if
		M == N -> M;
		M > N -> gcd(M - N, N);
		M < N -> gcd(M, N - M)
	end.