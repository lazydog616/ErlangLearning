-module(player).
-export([playing/2]).

playing(Current_card_list, Dealer_pid) ->
	receive 
		{"Battle"} ->  
			case Current_card_list of
				[] -> Dealer_pid ! {self(), Current_card_list},
					playing([], Dealer_pid);

				_ ->[Card_turned | Remaing_cards] = Current_card_list, 
					Dealer_pid ! {self(), [Card_turned]},
					playing(Remaing_cards, Dealer_pid);
		{"War"} -> 
			if
				lists:flatlength(Current_card_list) >= 3 ->
					{Three_cards_turned, Remaing_cards} = lists:split(3, Current_card_list),
					Dealer_pid ! {self(), Three_cards_turned},
					playing(Remaing_cards, Dealer_pid);
				lists:flatlength(Current_card_list) < 3 ->
					Dealer_pid ! {self(), Current_card_list},
					playing([], Dealer_pid)
			end;
		{"Win", Card_list} -> 
			Card_list_update = Current_card_list ++ Card_list,
			playing(Card_list_update, Dealer_pid);
		{"Lose"} ->
			playing(Current_card_list, Dealer_pid)
	end.
