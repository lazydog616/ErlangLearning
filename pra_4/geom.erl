-module(geom).
-export([area/3]).

area(Shape, _H, _W) when (_H > 0) and (_W > 0) ->
	case Shape of
		rectangle -> _H * _W;
		triangle -> _H * _W /2;
		elipse -> _H * _W * math:pi()
	end. 
