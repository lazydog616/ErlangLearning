-module(dates).
-export([enter_date/0, date_parts/1]).

-spec(date_parts(string()) -> list(number(), number(), number())).

enter_date()-> 
	Date = get_chars("enter the date", 10),
	date_parts(Date).

date_parts(Date) ->
	re:split(Date, "-", [{return, list}]). 
