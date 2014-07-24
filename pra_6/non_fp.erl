-module(non_fp).
-export([generate_teeth/2]).

-spec(generate_teeth(string(), number()) -> list()).
%@description : Is_teeth_present is a string where each char as $T or $F, which indicates the related tooth is present
% or not, Good_tooth_probablity is the probability of the health of a tooth, output is a list of lists of depth info
% of each tooth. 
generate_teeth(Is_teeth_present, Good_tooth_probability) ->
	generate_teeth(Is_teeth_present, Good_tooth_probability, []).



-spec(generate_teeth(string(), number(), list()) -> list()). 
generate_teeth([], _Good_tooth_probability, Accumulated_list) ->
	lists:reverse(Accumulated_list);

generate_teeth([Head|Tail], Good_tooth_probability, Accumulated_list) ->
	case Head of
		$F -> generate_teeth(Tail, Good_tooth_probability, [[0] | Accumulated_list]);
		$T -> generate_teeth(Tail, Good_tooth_probability, [generate_teeth(Good_tooth_probability)|Accumulated_list])
	end.


generate_teeth(Good_tooth_probability) ->
	random:seed(now()),
	Random_num = random:uniform(),
	io:format("Base_depth pro is ~w \n", [Random_num]),
	if
		Random_num > Good_tooth_probability ->
			Base_depth = 3;
		Random_num =< Good_tooth_probability ->
			Base_depth = 2		
	end,
	generate_tooth(Base_depth, 6, []).

-spec(generate_tooth(number(), number(), list()) -> list()).
generate_tooth(_, 0, Accumulated_list) -> Accumulated_list;
generate_tooth(Base_depth, Left_to_generate, Accumulated_list) ->
	
	random:seed(now()*random:uniform(1000)),
	Random_num = random:uniform(),
	io:format("Add_item pro is ~w \n", [Random_num]),
	if
		Random_num >= 0.5 -> Add_item = 1;
		Random_num < 0.5 -> Add_item = -1
	end,
	generate_tooth(Base_depth, Left_to_generate - 1, [Base_depth + Add_item | Accumulated_list]).
