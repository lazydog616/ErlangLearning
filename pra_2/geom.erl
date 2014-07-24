%% @author Xiao Zeng

%% @copyright 2014 by Xiao Zeng
%% @version 1.0 
%% @doc module: geom
 	
-module(geom).
-export([area/2]).

%% @doc calculate a flat area
area(H,W) -> H*W.