:- use_module(library(lists)).
:- consult('display.pl').

%devolve o Board inicial
%board(-Board)
board([
            ['r'],  
          [' ',' '],
        [' ','r',' '],
      [' ',' ',' ','b'],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        ['b',' ',' '],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        [' ',' ',' '],
          [' ',' '],
            ['b'] 
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
	display_game(GameState,Player).
	
%inicializar o GameState com uma lista de listas com informação do estado de jogo inicial
%initial(-GameState)
initial(GameState) :-
	board(Board),
	unused_pieces(UnusedPiecesL),
	out_pieces(OutPiecesL),
	player(Player),
  UnusedPieces =.. [unusedPieces|UnusedPiecesL],
  OutPieces =.. [outPieces|OutPiecesL],
	GameState =.. [gameState,Board,UnusedPieces,OutPieces,Player],
  get_number_void(Board,Red,Blue),
  format("~p ~p~n",[Red,Blue]).
	
%percorre a lista gameState e devolve o player
%get_player(+GameState,-Player)
get_player(gameState(_,_,_,Player),Player).

put(GameState).
    
game_over(gameState(_,unused_pieces(R0,B0,R1,B1),_,_),Winner) :-
  R0=0,
  R1=0,
  B0=0,
  B1=0.

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



get_number_void([L1|Tail],Red,Blue) :- 
  Red is 0,
  Blue is 0,
  nth0(0,L1,Piece),
  Piece = 'b',
  !,
  get_right_elem(L1,Red1,Blue1),
  get_number_void(Tail,Red2,Blue2),
  B is Blue1 + Blue2,
  AuxB is B + 1,
  AuxR is Red1 + Red2,
  Blue is AuxB,
  Red is AuxR.

get_number_void([L1|Tail],Red,Blue) :- 
  nth0(0,L1,Piece),
  Piece = 'r',
  !,
  get_right_elem(L1,Red1,Blue1),
  get_number_void(Tail,Red2,Blue2),
  R is Red1 +Red2,
  AuxB is Blue1 + Blue2,
  AuxR is R + 1,
  Blue is AuxB,
  Red is AuxR.

get_number_void([L1|Tail],Red,Blue) :- 
  nth0(0,L1,Piece),
  Piece = ' ',
  !,
  get_right_elem(L1,Red1,Blue1),
  get_number_void(Tail,Red2,Blue2),
  AuxB is Blue1 + Blue2,
  AuxR is Red1 + Red2,
  Blue is AuxB,
  Red is AuxR.

get_number_void(_,Red,Blue) :-
  Red is 0,
  Blue is 0.

%devolve verdade se o parâmetro for par
even(X) :- 0 is mod(X, 2).
%devolve verdade se o parâmetro for ímpar
odd(X) :- 1 is mod(X, 2).
    
