	
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
    format("|                                4                               |~n",[]),
    format("|                              _____                             |~n",[]),
    format("|Blue Bonus               3   /     \\   5               Red Bonus|~n",[]),
    format("|Pieces: ~p              _____/   ~p   \\_____             Pieces: ~p|~n",[BluePointPiece,Elem,RedPointPiece]),
    N1 is NumLinha +1,
    print_line(N1,RestoLista,VoidPieces),
    !.
print_line(NumLinha,[Elem | RestoLista],OutPieces) :-
    NumLinha = 2,
    format("|                  2   /     \\       /     \\   6                 |~n",[]),
    format("|                _____/   ~p   \\_____/   ~p   \\_____               |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista,OutPieces),
    !.
print_line(NumLinha,[Elem | RestoLista],OutPieces) :-
    NumLinha = 3,
    format("|           1   /     \\       /     \\       /     \\   7          |~n",[]),
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
    format("|                             \\_____/                            |~n",[]),
    format("|                                                                |~n",[]),
    format("|________________________________________________________________|~n",[]).
