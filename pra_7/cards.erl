-module(cards).
-export([make_deck/0, shuffle/1]).

-spec(make_deck() -> list()).

make_deck() ->
	Numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"],
	Patterns = ["Diamound", "Clubs", "Hearts", "Spades"],
	[{X, Y} || X <- Numbers, Y <- Patterns].



%explaining to Etude 7-6 (shuffle/1) : this algorithm is a recursion algorithm, in each round of recursion
%it randomly pick one card in the remaining deck and put it in Acc side, untill all the deck are 
%transformed from the priginal deck to the Acc side

shuffle(List) -> shuffle(List, []).
shuffle([], Acc) -> Acc;
shuffle(List, Acc) ->
  {Leading, [H | T]} = lists:split(random:uniform(length(List)) - 1, List),
  shuffle(Leading ++ T, [H | Acc]).