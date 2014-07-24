-module(teeth).
-export([alert/1]).

-spec(alert(list()) -> list()).


%@description : input a list of 32 lists of six numbers as its input, to represent the "pockets" depth info for 
%every 32 teeth, and return the list of unhealthy teeth.

alert(List_depth) -> 
	Sick_tooth_list = alert(List_depth, [], 1),
	lists:reverse(Sick_tooth_list).

%@description : 
alert([], Sick_tooth_list, _Current_idx) -> Sick_tooth_list;
alert([Head|Tail], Sick_tooth_list, Current_idx) -> 
	case check_list_element_larger_than_A(Head, 4) of
		 true -> alert(Tail, [Current_idx | Sick_tooth_list], Current_idx + 1);
		 false -> alert(Tail, Sick_tooth_list, Current_idx + 1) 
	end.

%@description : check if there's an element in the list is larger than A
check_list_element_larger_than_A([Head|Tail], A) -> 
	if
		Head >= A -> true;
 		Head < A -> check_list_element_larger_than_A(Tail, A)
	end;

check_list_element_larger_than_A([], _A) -> false.