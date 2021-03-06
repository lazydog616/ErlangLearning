-module(stats).
-export([minimum/1, maximum/1, range/1, mean/1, stdv/1, julian/1, julian2/1]).

-spec(minimum(list()) -> number()).
-spec(maximum(list()) -> number()).
-spec(range(list()) -> list()).
-spec(julian(string()) -> number()).
%-spec(julian2(string()) -> number()).
-spec(mean(list()) -> number()).
-spec(stdv(list()) -> number()).

%@description : minimum/1 returns the minimum value of a list
minimum([]) -> io:format("please enter an list which is not empty /n");
minimum([Head|Tail]) -> minimum([Head|Tail], Head).

minimum([], Element) -> Element;
minimum([Head|Tail], Element) -> 
	if
		Head < Element -> minimum(Tail, Head);
		Head >= Element -> minimum(Tail, Element)
	end.


%@description : maximum/1 returns the maximum value of a list
maximum([]) -> io:format("please enter an list which is not empty /n");
maximum([Head|Tail]) -> maximum([Head|Tail], Head).

maximum([], Element) -> Element;
maximum([Head|Tail], Element) ->
	if
		Head >= Element -> maximum(Tail, Head);
		Head < Element -> maximum(Tail, Element)
	end.


%description : range/1 returns the range of values in a list

range([]) -> io:format("empty list entered /n");
range(List) ->
	Max = maximum(List),
	Min = minimum(List),
	Range = [Min, Max],
	Range.

%@description : returns true if the Year is a leap year, false otherwise

is_leap_year(Year) -> 
	(Year rem 4 == 0 andalso Year rem 100 /= 0) 
		orelse(Year rem 400 == 0).


%description : julian/1 Given a string in ISO format("yyyy-mm-dd")
%, it returns the Julian date : the day of the year.

julian(ISO_Date) -> 
	Date_list = dates:date_parts(ISO_Date),
	[Year, Month, Day] = Date_list,
	case is_leap_year(Year) of
		true -> Feb_days = 29;
		false -> Feb_days = 28
	end,
	Day_amount_each_month = [31,Feb_days,31,30,31,30,31,31,30,31,30,31],
	
	julian(Year, Month, Day, Day_amount_each_month, 0).

julian(Year, 1, Day, Day_amount_each_month, Accumulator) -> Accumulator + Day;
julian(Year, Month, Day, [Head|Tail], Accumulator) -> 
	julian(Year, Month - 1, Day, Tail, Accumulator + Head).

julian2(ISO_Date) ->
	Date_list = dates:date_parts(ISO_Date),
	[Year, Month, Day] = Date_list,
	case is_leap_year(Year) of
		true -> Feb_days = 29;
		false -> Feb_days = 28
	end,
	Day_amount_each_month = [31,Feb_days,31,30,31,30,31,31,30,31,30,31],
	Head = element(1, lists:split(Month - 1, Day_amount_each_month)),
	Days_need_to_sum = [Day | Head], 	
	lists:foldl(fun(X, Sum) -> Sum + X end, 0, Days_need_to_sum).

%description : calculate the mean value of a list
mean(List) -> 
	Sum = lists:foldl(fun(X, Sum) -> X + Sum end, 0, List),
	Sum/lists:flatlength(List).

%@description : calculate standard derivative of a list
stdv(List) ->
	Sum = lists:foldl(fun(X, Sum) -> X + Sum end, 0, List),
	Sum_of_squares = lists:foldl(fun(X, Squre_sum) -> Squre_sum + X * X end, 0, List),
	N = lists:flatlength(List),
	Result = math:sqrt((N * Sum_of_squares - Sum * Sum)/(N * (N - 1))).

