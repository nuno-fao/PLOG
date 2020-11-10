:- use_module(library(lists)).
:- consult('display.pl').

%devolve o Board inicial
%board(-Board)
board([
            [' '],  
          [' ',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        [' ',' ',' '],
          [' ',' '],
            [' '] 
]).
%unused_pieces(-UnusedPieces)
unused_pieces([10,5,5,10]).
%out_pieces(-OutPieces)
out_pieces([0,0,0,0]).
%player(-Player)
player(0).

%inicia o jogo e o estado de jogo mostrando depois o tabuleiro
play :-
	initial(GameState),
	get_player(GameState,Player),
	display_game(GameState,Player),
  format("~n~n",[]),
  loop(GameState).

loop(GameState,Winner) :-
  Winner = -1,
  read(Read),
	get_player(GameState,Player),
  display_game(GameState,Player),
  game_over(GameState,Winner1),
  loop(GameState,Winner1),
  !.

loop(GameState,Winner) :-
  format("Winner: ~p~n",[Winner]).

loop(GameState) :-
  loop(GameState,-1).

%inicializar o GameState com uma lista de listas com informação do estado de jogo inicial
%initial(-GameState)
initial(GameState) :-
	board(Board),
	unused_pieces(UnusedPiecesL),
	out_pieces(OutPiecesL),
	player(Player),
  UnusedPieces =.. [unusedPieces|UnusedPiecesL],
  OutPieces =.. [outPieces|OutPiecesL],
	GameState =.. [gameState,Board,UnusedPieces,OutPieces,Player].
	
%percorre a lista gameState e devolve o player
%get_player(+GameState,-Player)
get_player(gameState(_,_,_,Player),Player).

put(GameState).
    
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

get_winner(P1,P2,Red,Blue,OutPieces,Winner) :-
  P2 < P1,
  Winner is 0,
  !.

get_winner(P1,P2,Red,Blue,OutPieces,Winner) :-
  Red < Blue,
  Winner is 0,
  !.

get_winner(P1,P2,Red,Blue,OutPieces,Winner) :-
  Blue < Red,
  Winner is 1,
  !.
get_winner(P1,P2,Red,Blue,outPieces(_,_,R0,R1),Winner) :-
  R0 < R1,
  Winner is 0,
  !.
get_winner(P1,P2,Red,Blue,outPieces(_,_,R0,R1),Winner) :-
  R1 < R0,
  Winner is 1,
  !.
get_winner(P1,P2,Red,Blue,outPieces(_,_,R0,R1),Winner) :-
  Winner is 2.


get_points(P1,P2,Red,Blue,outPieces(B0,B1,R0,R1)) :-
  Red > Blue,
  P1 is B0 - R0,
  P2 is B1,
  !.
get_points(P1,P2,Red,Blue,outPieces(B0,B1,R0,R1)) :-
  Blue > Red,
  P1 is B0,
  P2 is B1 - R1,
  !.
get_points(P1,P2,Red,Blue,outPieces(B0,B1,R0,R1)) :-
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

get_number_void(Board,Red,Blue) :-
  get_number_void(Board,Red,Blue,0).

get_number_void([L1|Tail],Red,Blue,N):-
  N>3,
  N<9,
  even(N),
  !,
  N1 is N +1,
  get_number_void(Tail,Red,Blue,N1).

get_number_void([L1|Tail],Red,Blue,N) :- 
  nth0(0,L1,Piece),
  Piece = 'b',
  !,
  get_right_elem(L1,Red1,Blue1),
  N1 is N+1,
  get_number_void(Tail,Red2,Blue2,N1),
  B is Blue1 + Blue2,
  AuxB is B + 1,
  AuxR is Red1 + Red2,
  Blue is AuxB,
  Red is AuxR.

get_number_void([L1|Tail],Red,Blue,N) :- 
  nth0(0,L1,Piece),
  Piece = 'r',
  !,
  get_right_elem(L1,Red1,Blue1),
  N1 is N+1,
  get_number_void(Tail,Red2,Blue2,N1),
  R is Red1 +Red2,
  AuxB is Blue1 + Blue2,
  AuxR is R + 1,
  Blue is AuxB,
  Red is AuxR.

get_number_void([L1|Tail],Red,Blue,N) :- 
  nth0(0,L1,Piece),
  Piece = ' ',
  !,
  get_right_elem(L1,Red1,Blue1),
  N1 is N+1,
  get_number_void(Tail,Red2,Blue2,N1),
  AuxB is Blue1 + Blue2,
  AuxR is Red1 + Red2,
  Blue is AuxB,
  Red is AuxR.

get_number_void(_,Red,Blue,_) :-
  Red is 0,
  Blue is 0.

%devolve verdade se o parâmetro for par
even(X) :- 0 is mod(X, 2).
%devolve verdade se o parâmetro for ímpar
odd(X) :- 1 is mod(X, 2).
    
