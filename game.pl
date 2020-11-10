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
unused_pieces([[10,5],[5,10]]).
%out_pieces(-OutPieces)
out_pieces([[0,0],[0,0]]).
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
	unused_pieces(UnusedPieces),
	out_pieces(OutPieces),
	player(Player),
	GameState = [Board,UnusedPieces,OutPieces,Player].
	
%percorre a lista gameState e devolve o player
%get_player(+GameState,-Player)
get_player([_|[_|[_|[Player|_]]]],Player).
    
%devolve verdade se o parâmetro for par
even(X) :- 0 is mod(X, 2).
%devolve verdade se o parâmetro for ímpar
odd(X) :- 1 is mod(X, 2).
    
