-module(player).
-export([playing/2]).

playing(Current_card_list, Dealer_pid) ->
    receive
   	 {"Battle"} ->  
   		 case Current_card_list of
   			 [] -> 
               io:format("~p go to Battle, with card ~p, Remaing_cards : ~p ~n", [self(), Current_card_list, []]),
               Dealer_pid ! {self(), Current_card_list},
   				 playing([], Dealer_pid);

   			 _ ->
               [Card_turned | Remaing_cards] = Current_card_list,
               io:format("~p go to Battle, with card ~p, Remaing_cards : ~p ~n", [self(), Card_turned, Remaing_cards]),
   				 Dealer_pid ! {self(), [Card_turned]},
   				 playing(Remaing_cards, Dealer_pid)
            end;
   	 {"War"} ->
            List_Length = lists:flatlength(Current_card_list),
   		 if
   			 List_Length >= 3 ->
   				 {Three_cards_turned, Remaing_cards} = lists:split(3, Current_card_list),
                io:format("~p go to War, with card ~p, Remaing_cards : ~p ~n", [self(), Three_cards_turned, Remaing_cards]),
   				 Dealer_pid ! {self(), Three_cards_turned},
   				 playing(Remaing_cards, Dealer_pid);
   			 List_Length< 3 ->
               io:format("~p go to War, with card ~p, Remaing_cards : ~p ~n", [self(), Current_card_list, []]),
   				 Dealer_pid ! {self(), Current_card_list},
   				 playing([], Dealer_pid)
   		 end;
   	 {"Win", Card_list} ->
   		 Card_list_update = Current_card_list ++ Card_list,
          io:format("~p Win, Current Cards : ~p ~n", [self(), Card_list_update]),
          io:format("********************* end of round ************************~n"),
   		 playing(Card_list_update, Dealer_pid);

   	{"Lose"} ->
          io:format("~p Lose, Current Cards : ~p ~n", [self(), Current_card_list]),
          io:format("********************* end of round ************************~n"),
   		 playing(Current_card_list, Dealer_pid)
   end.
