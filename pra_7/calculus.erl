-module(calculus).
-export([derivative/2]).

-spec(derivative(number(), function()) -> number()).

%@description : output the derivative of Function Func at value Value
derivative(Value, Func) -> 
	Delta = 1.0e-10,
	Derivative = (Func(Value + Delta) - Func(Value)) / Delta,
	Derivative. 	 
	