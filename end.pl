game_over(gameState(Board,unusedPieces(R0,B0,R1,B1),OutPieces,_),Winner) :-
  R0=0,
  R1=0,
  B0=0,
  B1=0,
  get_number_void(Board,Red,Blue),
  get_points(P1,P2,Red,Blue,OutPieces),
  get_winner(P1,P2,Red,Blue,OutPieces,Winner),
  arg(2,OutPieces,Risk0),
  arg(3,OutPieces,Risk1),
  format("Player0 Points: ~p ~p ~p ~n",[P1,Red,Risk0]),
  format("Player1 Points: ~p ~p ~p ~n",[P2,Blue,Risk1]).
game_over(_,Winner) :-
  Winner is -1.





get_winner(P1,P2,_,_,_,Winner) :-
  P1 < P2,
  Winner is 1,
  !.
get_winner(P1,P2,_,_,_,Winner) :-
  P2 < P1,
  Winner is 0,
  !.
get_winner(_,_,Red,Blue,_,Winner) :-
  Red < Blue,
  Winner is 0,
  !.
get_winner(_,_,Red,Blue,_,Winner) :-
  Blue < Red,
  Winner is 1,
  !.
get_winner(_,_,_,_,outPieces(_,_,R0,R1),Winner) :-
  R0 < R1,
  Winner is 0,
  !.
get_winner(_,_,_,_,outPieces(_,_,R0,R1),Winner) :-
  R1 < R0,
  Winner is 1,
  !.
get_winner(_,_,_,_,_,Winner) :-
  Winner is 2.




get_points(P1,P2,Red,Blue,outPieces(B0,B1,R0,_)) :-
  Red > Blue,
  P1 is B0 - R0,
  P2 is B1,
  !.
get_points(P1,P2,Red,Blue,outPieces(B0,B1,_,R1)) :-
  Blue > Red,
  P1 is B0,
  P2 is B1 - R1,
  !.
get_points(P1,P2,_,_,outPieces(B0,B1,_,_)) :-
  P1 is B0,
  P2 is B1.




get_right_elem(L1,Red,Blue) :-
  same_length(L1,[1]),
  Red is 0,
  Blue is 0,
  !.
get_right_elem(L1,Red,Blue) :-
  last(L1,LastE),
  LastE = ' ',
  Red is 0,
  Blue is 0,
  !.
get_right_elem(L1,Red,Blue) :-
  last(L1,LastE),
  LastE = 'r',
  Red is 1,
  Blue is 0,
  !.
get_right_elem(L1,Red,Blue) :-
  last(L1,LastE),
  LastE = 'b',
  Red is 0,
  Blue is 1.