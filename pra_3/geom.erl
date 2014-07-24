%% @author Xiao Zeng
%% @copyright 2014 @ Xiao Zeng
%% @doc geom module

-module(geom).
-export([area/1]).

%% @doc area function to calculate different type of geometry,
%% when hight or weight is less than zero, use underscore to 
%%output zero, no geo type entered, also output zero

area({rectangle, _H, _W}) when (_H > 0) and (_W > 0) -> _H * _W; 

area({triangle, _H, _W}) when (_H > 0) and (_W > 0) -> _H * _W / 2 ;

area({elipse, _H, _W}) when (_H > 0) and (_W > 0) -> _H * _W * math:pi() ;

area({_, _, _}) -> 0 .