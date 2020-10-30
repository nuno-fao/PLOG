initial_board([[1],[1,2],[1,2,3],[1,2,3,4],[1,2,3],[1,2,3,4],[1,2,3],[1,2,3,4],[1,2,3],[1,2,3,4],[1,2,3],[1,2],[1]]).



play :-
    initial(GameState),
    display_game(GameState,Player),
    setPointsOf(GameState,1,20),
    display_game(GameState,Player).
    %play(Board,_,Player).

initial(GameState) :-
    initial_board(Board),
    setBoard(GameState,Board),
    setPointsOf(GameState,0,0),
    setPointsOf(GameState,1,0),
    setActivePlayer(GameState,0).
    

setBoard(GameState,Board) :- 
    retract(board(GameState,Board)),
    assert(board(GameState,Board)).
setBoard(GameState,Board) :- 
    assert(board(GameState,Board)).
getBoard(GameState,Board) :- 
    retract(board(GameState,Board)),
    assert(board(GameState,Board)).



setActivePlayer(GameState,Player) :-
    retract(activePlayer(GameState,Player)),
    assert(activePlayer(GameState,Player)).
setActivePlayer(GameState,Player) :-
    assert(activePlayer(GameState,Player)).

setPointsOf(GameState,Player,Points) :-
    retract(pointsOf(GameState,Player,_)),
    assert(pointsOf(GameState,Player,Points)).
setPointsOf(GameState,Player,Points) :-
    assert(pointsOf(GameState,Player,Points)).
seePointsOf(GameState,Player,Points) :-
    retract(pointsOf(GameState,Player,Points)),
    assert(pointsOf(GameState,Player,Points)).    






display_game(GameState,Player):-
    seePointsOf(GameState,0,Points0),
    seePointsOf(GameState,1,Points1),
    format("Player1: ~p ~n",[Points0]),
    format("Player2: ~p ~n",[Points1]),
    getBoard(GameState,Board),
    print_line(Board).

print_line([Elem | RestoLista]) :-
    NumLinha = 1,
    format("-----------------------_____-----------------------~n",[]),
    format("|                     /     \\                     |~n",[]),
    format("|               _____/   ~p   \\_____               |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 2,
    format("|              /     \\       /     \\              |~n",[]),
    format("|        _____/   ~p   \\_____/   ~p   \\_____        |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 3,
    format("|       /     \\       /     \\       /     \\       |~n",[]),
    format("| _____/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____ |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 4,
    format("|/     \\       /     \\       /     \\       /     \\|~n",[]),
    format("/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 5,
    format("\\       /     \\       /     \\       /     \\       /~n",[]),
    format(" \\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 6,
    format(" /     \\       /     \\       /     \\       /     \\~n",[]),
    format("/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).
print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 7,
    format("\\       /     \\       /     \\       /     \\       /~n",[]),
    format(" \\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 8,
    format(" /     \\       /     \\       /     \\       /     \\~n",[]),
    format("/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).
print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 9,
    format("\\       /     \\       /     \\       /     \\       /~n",[]),
    format(" \\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 10,
    format(" /     \\       /     \\       /     \\       /     \\~n",[]),
    format("/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 11,
    format("\\       /     \\       /     \\       /     \\       /~n",[]),
    format("|\\_____/   ~p   \\_____/   ~p   \\_____/   ~p   \\_____/|~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 12,
    format("|      \\       /     \\       /     \\       /      |~n",[]),
    format("|       \\_____/   ~p   \\_____/   ~p   \\_____/       |~n",Elem),
    N1 is NumLinha +1,
    print_line(N1,RestoLista).

print_line(NumLinha,[Elem | RestoLista]) :-
    NumLinha = 13,
    format("|             \\       /     \\       /             |~n",[]),
    format("|              \\_____/   ~p   \\_____/              |~n",Elem),
    format("|                    \\       /                    |~n",[]),
    format("|_____________________\\_____/_____________________|~n",[]),
    N1 is NumLinha +1.