:- use_module(library(lists)).

%devolve o Board inicial
%initial_board(-Board)
initial_board([
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
%initial_unused_pieces(-UnusedPieces)
initial_unused_pieces([[10,5],[5,10]]).
%initial_out_pieces(-OutPieces)
initial_out_pieces([[0,0],[0,0]]).
%initial_player(-Player)
initial_player(0).


intermediate_board([
            [' '],  
          [' ',' '],
        [' ','R','B'],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ','R',' '],
        ['B',' ',' '],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        ['B',' ',' '],
          ['B',' '],
            [' '] 
]).
intermediate_unused_pieces([[7,2],[2,8]]).
intermediate_out_pieces([[4,0],[0,1]]).
intermesdiate_player(1).

%inicializar o GameState com uma lista de listas com informação do estado de jogo intermédio
intermediate_state(GameState) :-
	intermediate_board(Board),
	intermediate_unused_pieces(UnusedPieces),
	intermediate_out_pieces(OutPieces),
	intermesdiate_player(Player),
	GameState = [Board,UnusedPieces,OutPieces,Player].
	
final_board([
            [' '],  
          [' ',' '],
        [' ','R','B'],
      [' ','R',' ',' '],
        [' ',' ',' '],
      [' ',' ','R',' '],
        ['B',' ','B'],
      [' ',' ','B',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        ['B',' ',' '],
          ['B',' '],
            [' '] 
]).
final_unused_pieces([[0,0],[0,0]]).
final_out_pieces([[12,4],[0,3]]).
final_player(1).

%inicializar o GameState com uma lista de listas com informação do estado de jogo final
final_state(GameState) :-
	final_board(Board),
	final_unused_pieces(UnusedPieces),
	final_out_pieces(OutPieces),
	final_player(Player),
	GameState = [Board,UnusedPieces,OutPieces,Player].

%inicia o jogo e o estado de jogo mostrando depois o tabuleiro
play :-
	initial(GameState),
	get_player(GameState,Player),
	display_game(GameState,Player).
	
%inicializar o GameState com uma lista de listas com informação do estado de jogo inicial
%initial(-GameState)
initial(GameState) :-
	initial_board(Board),
	initial_unused_pieces(UnusedPieces),
	initial_out_pieces(OutPieces),
	initial_player(Player),
	GameState = [Board,UnusedPieces,OutPieces,Player].
	
%percorre a lista gameState e devolve o player
%get_player(+GameState,-Player)
get_player([_|[_|[_|[Player|_]]]],Player).
	
%imprime as informações do estado de cada jogador e chama a predicado que imprime o tabuleiro
%display_game(+GameState,+Player)
display_game([Board|[[[UnusedRed0|[UnusedBlue0|_]]|[[UnusedRed1|[UnusedBlue1|A]]]]|[OutPieces|_]]],Player):-
    format("Jogador 0                 Vez do Jogador                 Jogador 1~n",[]),	
    format("Red Pieces: ~p                    ~p                   Red Pieces: ~p~n",[UnusedRed0,Player,UnusedRed1]),	
    format("Blue Pieces: ~p                                      Blue Pieces: ~p~n",[UnusedBlue0,UnusedBlue1]),	
    print_line(Board,OutPieces).

%predicado que imprime o tabuleiro(uma vez que o tabuleiro varia o seu tamanho, cada linha tem uma forma de imprimir diferente)
%print_line(+GameState)
print_line([[Elem|_] | RestoLista],[[RedPointPiece|[BluePointPiece|_]]|VoidPieces]) :-
    NumLinha = 1,
    format("__________________________________________________________________~n",[]),
    format("|Blue Bonus                   /     \\                   Red Bonus|~n",[]),
    format("|Pieces: ~p              _____/   ~p   \\_____             Pieces: ~p|~n",[BluePointPiece,Elem,RedPointPiece]),
    N1 is NumLinha +1,
    print_line(N1,RestoLista,VoidPieces),
    !.
print_line(NumLinha,[Elem | RestoLista],OutPieces) :-
    NumLinha = 2,
    format("|                      /     \\       /     \\                     |~n",[]),
    format("|                _____/   ~p   \\_____/   ~p   \\_____               |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista,OutPieces),
    !.
print_line(NumLinha,[Elem | RestoLista],OutPieces) :-
    NumLinha = 3,
    format("|               /     \\       /     \\       /     \\              |~n",[]),
    format("|         _____/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____        |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista,OutPieces),
    !.
print_line(NumLinha,[Elem | RestoLista],OutPieces) :-
    NumLinha >= 4,
    even(NumLinha),
    NumLinha <12,
    format("|        /     \\       /     \\       /     \\       /     \\       |~n",[]),
    format("|       /   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\      |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista,OutPieces),
    !.
print_line(NumLinha,[Elem | RestoLista],OutPieces) :-
    NumLinha >= 4,
    odd(NumLinha),
    NumLinha < 12,
    format("|       \\       /     \\       /     \\       /     \\       /      |~n",[]),
    format("|        \\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/       |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista,OutPieces),
    !.
print_line(NumLinha,[Elem | RestoLista],OutPieces) :-
    NumLinha = 12,
    format("|              \\       /     \\       /     \\       /             |~n",[]),
    format("|               \\_____/   ~p   \\_____/   ~p   \\_____/              |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista,OutPieces),
    !.
print_line(NumLinha,[Elem | _],[VoidPieces|_]) :-
    NumLinha = 13,
    format("|Red Risk             \\       /     \\       /           Blue Risk|~n",[]),
    format("|                      \\_____/   ~p   \\_____/                     |~n",Elem),
    format("|Pieces: ~p                   \\       /                  Pieces: ~p|~n",VoidPieces),
    format("|_____________________________\\_____/____________________________|~n",[]).
    
%devolve verdade se o parâmetro for par
even(X) :- 0 is mod(X, 2).
%devolve verdade se o parâmetro for ímpar
odd(X) :- 1 is mod(X, 2).
    
