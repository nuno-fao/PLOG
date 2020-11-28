:- use_module(library(lists)).
:- consult('display.pl').
:- consult('end.pl').
:- consult('moves.pl').
:- consult('board_map.pl').
:- consult('menus.pl').
:- dynamic controller/2.
:- dynamic difficulty/1.
%:- consult('AI.pl').
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

controller(0,'undefined').
controller(1,'undefined').
difficulty('undefined').

%inicia o jogo e o estado de jogo mostrando depois o tabuleiro
play :-
	initial(GameState),
  mainMenu,
  check_exit,
	get_player(GameState,Player),
	display_game(GameState,Player),
  format("~n~n",[]),
  loop(GameState,-1),
  play.
play.

loop(GameState,Winner) :-
  Winner = -1,
	get_player(GameState,PlayerInit),
  controller(PlayerInit,Controller),
  getMoveFromController(Controller,Colour,Column1,Line1),
  verifyNotInVoid(Column1, Line1),
  ext_to_int(Column1, Line1, Line, Column),
  Target =.. [target,Colour,Column,Line,Column1,Line1],
  move(GameState,Target,NewGameState),
	get_player(NewGameState,Player),
  %valid_moves(NewGameState,Player,ListOfMoves),
  display_game(NewGameState,Player),
  game_over(NewGameState,Winner1),
  %ai(NewGameState,AA),
  %retract(moves(AA,[MColour,MX,MY])),
  %ext_to_int(CP,CL,MY,MX),
  %MTarget =.. [target,MColour,MX,MY,CP,CL],
  %move(NewGameState,MTarget,MGameState),
	%get_player(MGameState,Player),
  %display_game(MGameState,Player),
  %game_over(MGameState,Winner1),
  !,
  loop(NewGameState,Winner1).

loop(GameState,Winner) :-
  Winner = -1,
  game_over(GameState,Winner),
  format("Invalid Input~n",[]),
  !,
  loop(GameState,Winner).

loop(_,Winner) :-
  format("Winner: ~p~n",[Winner]).

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

%devolve verdade se o parâmetro for par
even(X) :- 0 is mod(X, 2).
%devolve verdade se o parâmetro for ímpar
odd(X) :- 1 is mod(X, 2).

askForMove(Colour,Column,Line):-
  format("Which piece to Use(r or b): ",[]),
  read(Read),
  (Read == 'r';Read == 'b'),
  format("Which Column to put It: ",[]),
  read(ColumnAux), number(ColumnAux),
  format("Which Line to put It: ",[]),
  read(LineAux), number(LineAux), !,
  Colour = Read,
  Column = ColumnAux,
  Line = LineAux.

  check_exit:-
    controller(0,Controller0),
    controller(1,Controller1),
    Controller0 \= 'E',
    Controller1 \= 'E'.


getMoveFromController('P',Colour,Column1,Line1):-
  !,
  askForMove(Colour,Column1,Line1).

getMoveFromController('AI',Colour,Column1,Line1). %é preciso fazer