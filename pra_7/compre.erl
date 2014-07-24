-module(compre).
-export([process/3]).

-spec(process(list(), char(), number()) -> list()).

%@description : input a list of people info with name, gender and age, output the names of a specific gender 
% over a specific age
%Sample input list : People = [{"Federico", $M, 22}, {"Kim", $F, 45}, {"Hansa", $F, 30},
%{"Tran", $M, 47}, {"Cathy", $F, 32}, {"Elias", $M, 50}].

process(Info_list, Gender, Age_threshold) -> 
	process(Info_list, Gender, Age_threshold, []).


process([], _Gender, _Age_threshold, Accumulated_list) -> Accumulated_list;

process([Head|Tail], Gender, Age_threshold, Accumulated_list) -> 
	if
		element(2, Head) == Gender andalso element(3, Head) > Age_threshold ->
			process(Tail, Gender, Age_threshold, [element(1,Head) | Accumulated_list]);
		 (element(2, Head) /= Gender) orelse (element(3, Head) =< Age_threshold) -> process(Tail, Gender, Age_threshold, Accumulated_list)
		 
	end.

