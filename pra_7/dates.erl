-module(dates).
-export([enter_date/0, date_parts/1]).


-spec(date_parts(string()) -> list()).


enter_date()-> 
	Date = io:get_chars("enter the date >", 10),
	date_parts(Date).

%@description : covert a ISO string format date into a list
%@sample : "1990-02-13" to [1990,0,13]
date_parts(Date) ->
	Dates = re:split(Date, "-", [{return, list}]),
	covert_to_NumList(Dates, []).

%@description : covert string list to number list
covert_to_NumList([], Re) -> Re;
covert_to_NumList([Head|Tail], Re) ->
	Head_Num = list_to_integer(Head),
	covert_to_NumList(Tail, Re ++ [Head_Num]).
