:- use_module(library(lists)).
:- use_module(library(random)).
%:- consult('swi-random.pl').
:- consult('display.pl').
:- consult('end.pl').
:- consult('moves.pl').
:- consult('board_map.pl').
:- consult('menus.pl').
:- dynamic controller/2.
:- dynamic difficulty/1.
:- consult('AI.pl').
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

% [Red0,Blue0,Red1,Blue1]
%unused_pieces(-UnusedPieces)
unused_pieces([10,5,5,10]).
% [RedBonus,BlueBonus,RedRisk,BlueRisk]
%out_pieces(-OutPieces)
out_pieces([0,0,0,0]).
%player(-Player)
player(0).

controller(0,'undefined').
controller(1,'undefined').
difficulty('undefined').

%inicia o jogo, mostra os menus e o estado de jogo mostrando depois o tabuleiro
play :-
	initial(GameState),
  main_menu,
  check_exit,
	get_player(GameState,Player),
	display_game(GameState,Player),
  format("~n~n",[]),
  loop(GameState,-1),
  play.
play.

%loop principal, obtem os moves e aplica-os, calcula o vencedor e caso seja igual a 0 ou 1, acaba o jogo
%caso o winner seja -1 significa que o jogo não acabou e continua o ciclo
%loop(+GameState,+Winner)
loop(GameState,-1) :-
	get_player(GameState,PlayerInit),
  controller(PlayerInit,Controller),
  get_move_from_controller(GameState,Controller,Colour,Column1,Line1),
  ext_to_int(Column1, Line1, Line, Column),
  Target =.. [target,Colour,Column,Line,Column1,Line1],
  move(GameState,Target,NewGameState),
	get_player(NewGameState,Player),
  display_game(NewGameState,Player),
  check_for_confirm(PlayerInit,[Colour,Column1,Line1]),
  game_over(NewGameState,Winner1),

  !,
  loop(NewGameState,Winner1).

%Algo correu mal, volta ao inicia sem mudar o GameState
loop(GameState,-1) :-
  game_over(GameState,Winner),
  format("Invalid Input~n",[]),
  !,
  loop(GameState,Winner).

%Fim Do jogo
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

%pede um move ao jogador e devolve esse move nos parametros do predicado
%caso seja possivel identificar um erro sintatico do input (cor = 4 por exemplo) o predicado falha
%ask_for_move(-Colour,-Column,-Line)
ask_for_move(Colour,Column,Line):-
  format("Which piece to Use(r or b): ",[]),
  read(Read),clear_buffer,
  (Read == 'r';Read == 'b'),
  format("Which Column to put It: ",[]),
  read(ColumnAux), number(ColumnAux),clear_buffer,
  format("Which Line to put It: ",[]),
  read(LineAux), number(LineAux), !,clear_buffer,
  Colour = Read,
  Column = ColumnAux,
  Line = LineAux.

%check_exit/0 falha caso os controllers estejam em estado saida('E')
check_exit:-
  controller(0,Controller0),
  controller(1,Controller1),
  Controller0 \= 'E',
  Controller1 \= 'E'.


%dependendo do tipo de controller(Pessoa ou AI), chama os predicados responsáveis por obter o moves respetivos
%get_move_from_controller(GameState,+Controller_Type,-Colour,-Column,-Line)
get_move_from_controller(_,'P',Colour,Column1,Line1):-
  !,
  ask_for_move(Colour,Column1,Line1).
get_move_from_controller(GameState,'AI',Colour,Column1,Line1):-
  get_player(GameState,Player),
  !,
  difficulty(Level),
  choose_move(GameState,Player,Level,[Colour,X,Y]),
  ext_to_int(Column1,Line1,Y,X).

%imprime o movimento efetuado e fica à espera de receber input(enter) para poder continuar o loop
%este predicado impede que o computador faça a sua jogada e que o jogador não consiga ver as alterações imediatas no tabuleiro
%previne também que o jogo AIxAI seja executado até ao fim quase instantaneamente
%check_for_confirm(+Player,+Move)
check_for_confirm(Player,Move):-
  controller(Player,C),
  C = 'AI',
  print('Computer has executed the move '),
  print(Move),
  print(', please press enter to proceed:'),
  skip_line.
check_for_confirm(Player,Move):-
  controller(Player,C),
  C = 'P',
  print('You Executed the move: '),
  print(Move),
  print(', please press enter to proceed:'),
  skip_line.

%limpa o buffer, reovendo os caracteres de newline introduzidos ao clicar em enter apó isnerir um move
clear_buffer:-
  get_char(_Char).

