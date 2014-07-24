-module(dates).
-export([enter_date/0]).

-spec(date_parts(string()) -> list()).

enter_date()-> 
	Date = io:get_chars("enter the date >", 10),
	date_parts(Date).

date_parts(Date) ->
	re:split(Date, "-", [{return, list}]). 
