-module(ask_area).
-export([area/0]).
-spec(area() -> number()).

area() ->
	Shape = char_to_shape(io:get_line("R)ectangle, T)riangle, E)lipse >")),
	Width = string_to_number(io:get_line("Enter width >")),
	io:format("width entered: ~w \n", [Width]),
	Height = string_to_number(io:get_line("Enter height >")),
	io:format("height entered: ~w \n", [Height]),
	area_cal(Shape, Height, Width).

-spec(string_to_number(string()) -> number()).

string_to_number(Number) ->
	{N, _ } = string:to_float(Number),
	N.

-spec(char_to_shape(char()) -> atom()).
char_to_shape(S) ->
	
	Shape = list_to_atom(S),
	Tmp = case Shape of
		'R\n' -> rectangle;
		'T\n' -> triangle;
		'E\n' -> ellipse;
		'r\n' -> rectangle;
		't\n' -> triangle;
		'e\n' -> elipse;
		_ -> unknown
	end,
	io:format("the current shape is ~p ~p \n", [Shape, Tmp]),
	Tmp.

-spec(area_cal(atom(), number(), number()) -> number()).

area_cal(S, H, W) when W >= 0, H >= 0 ->
	case S of
 		rectangle -> geom:area({rectangle, H, W});
 		triangle -> geom:area({triangle, H, W});
 		elipse -> geom:area({elipse, H, W});
 		_ -> io:format("unkown shape")
 	end;

area_cal(S, H, W) when (H < 0) ->
 	io:format("Height must to be positive");

area_cal(S, H, W) when (W < 0) ->
 	io:format("width must to be positive").


