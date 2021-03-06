
-module(dealer).
-export([dealing/1]).

%Card_Amount must to be even

% answer to Etude 8 's process asynchronous problem : 
% considering Erlang process's asyhcronous , so let “Win/Lose" signal sent first to lie
% in the player process's mailbox first, and then do dealing(Player1, Player2, "Pre_state", [], [], [], 0) to 
% send "Battle/War" signal to player process mail box, because "Win/Lose" is in front of "Battle/War" in 
% player's mail box, so "Win/Lose" is processed first, so wouldn't happen the kind of problem that: 
% "Battle/War" before "Win" bringing cards to the player 
% with no card in hand, causing this player lose game.

% But message is also asynchronous, so need to find out a way to check if "Win/Lose" is processed before next round's "War/Battle", 
% add sth around line 100

dealing(Card_Amount) ->
    {Shuffled_deck, _} = lists:split(Card_Amount, cards:shuffle(cards:make_deck())),
    {Cards_for_player1, Cards_for_player2} = lists:split(round(Card_Amount/2), Shuffled_deck),
    Player1 = spawn_link(player, playing, [Cards_for_player1, self()]),
    Player2 = spawn_link(player, playing, [Cards_for_player2, self()]),
    dealing(Player1, Player2, "Pre_state", [], [], [], 0).


dealing(Player1, Player2, Play_state, Cards_pile, Player1_card_list, Player2_card_list, Current_in_playerS) ->
    case Play_state of
     "Pre_state" ->
       case lists:flatlength(Cards_pile) of

         0 ->
          %io:format("Prestate : Battle ! ~n"), 
           Player1 ! {"Battle"},
           Player2 ! {"Battle"},
           dealing(Player1, Player2, "Await", Cards_pile, Player1_card_list, Player2_card_list, Current_in_playerS);
         _ -> 
           % io:format("Prestate : War ! ~n"),
            Player1 ! {"War"},
           Player2 ! {"War"},
           dealing(Player1, Player2, "Await", Cards_pile, Player1_card_list, Player2_card_list, Current_in_playerS)
         
       end;
     "Await" ->
       if
         Current_in_playerS < 2 ->
           receive
             {Player1, Cards_list} ->
               case lists:flatlength(Cards_list) of
                 0 ->
                   dealing(Player1, Player2, "Await", Cards_pile, Cards_list, Player2_card_list, Current_in_playerS + 1);
                 1 ->
                   dealing(Player1, Player2, "Await", Cards_pile, Cards_list, Player2_card_list, Current_in_playerS + 1);
                 2 ->
                   [Head_card | Tail_card]= Cards_list,
                   dealing(Player1, Player2, "Await", Cards_pile ++ Head_card, Tail_card, Player2_card_list, Current_in_playerS + 1);
                 3 ->
                   {First_two_cards, Thrid_card} = lists:split(2, Cards_list),
                   dealing(Player1, Player2, "Await", Cards_pile ++ First_two_cards, Thrid_card, Player2_card_list, Current_in_playerS + 1)
               
               end;
             {Player2, Cards_list2} ->
               case lists:flatlength(Cards_list2) of
                 0 ->
                   dealing(Player1, Player2, "Await", Cards_pile, Player1_card_list, Cards_list2, Current_in_playerS + 1);
                 1 ->
                   dealing(Player1, Player2, "Await", Cards_pile, Player1_card_list, Cards_list2, Current_in_playerS + 1);
                 
                 2 ->
                   [Head_card | Tail_card]= Cards_list2,
                   dealing(Player1, Player2, "Await", Cards_pile ++ Head_card, Player1_card_list, Tail_card, Current_in_playerS + 1);
               
                 3 ->
                   {First_two_cards, Thrid_card} = lists:split(2, Cards_list2),
                   dealing(Player1, Player2, "Await", Cards_pile ++ First_two_cards, Player1_card_list, Thrid_card, Current_in_playerS + 1)
               
               end
           end;
         Current_in_playerS == 2 -> dealing(Player1, Player2, "Check", Cards_pile, Player1_card_list, Player2_card_list, Current_in_playerS)

               
       end;
     "Check" ->
       Player1_card_list_length = lists:flatlength(Player1_card_list),
       Player2_card_list_length = lists:flatlength(Player2_card_list),
       if
          Player1_card_list_length == 0 ->
           Player1 ! {"Lose"},
           Player2 ! {"Win", Player1_card_list ++ Player2_card_list ++ Cards_pile},
           io:format("~p win the game ~n ", [Player2]);
         Player2_card_list_length == 0 ->
           Player1 ! {"Win", Player1_card_list ++ Player2_card_list ++ Cards_pile},
           Player2 ! {"Lose"},
           io:format("~pwin the game ~n ", [Player1]);
         Player1_card_list_length == 1 andalso Player2_card_list_length == 1 ->
           C1 = map_card_to_number(Player1_card_list),
           C2 = map_card_to_number(Player2_card_list),
           if
             C1 > C2 ->
               Player1 ! {"Win", Player1_card_list ++ Player2_card_list ++ Cards_pile},
               Player2 ! {"Lose"},
               % considering Erlang process's asyhcronous , so let “Win/Lose" signal sent first to lie
               % in the player's mailbox first, and then do dealing(Player1, Player2, "Pre_state", [], [], [], 0) to 
               % send "Battle/War" signal to player process mail box, because "Win/Lose" is in front of "Battle/War" in 
               % player's mail box, so wouldn't happen the kind of problem that: Battle before "Win" bringing cards to the player 
               % with no card currently, and this player lose game because of this. 
               dealing(Player1, Player2, "Pre_state", [], [], [], 0);
               
             C1 < C2 ->
               Player1 ! {"Lose"},
               Player2 ! {"Win", Player1_card_list ++ Player2_card_list ++ Cards_pile},
               dealing(Player1, Player2, "Pre_state", [], [], [], 0);
             C1 == C2 ->
               dealing(Player1, Player2, "Pre_state", Cards_pile ++ Player1_card_list ++ Player2_card_list, [], [], 0)
               
           end

       end
    end.

map_card_to_number(Card) ->
    [C | _] = Card,
    Card_info = element(1, C),
    case Card_info of
     "2" -> 0;
     "3" -> 1;
     "4" -> 2;
     "5" -> 3;
     "6" -> 4;
     "7" -> 5;
     "8" -> 6;
     "9" -> 7;
     "10" -> 8;
     "J" -> 9;
     "Q" -> 10;
     "K" -> 11;
     "A" -> 12
    end.