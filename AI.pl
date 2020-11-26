minimax(Pos, BestPos, Val, NodesList,D):-
    getStates(Pos,PosList,D), 
    !,
    print('\n'),
    print('\n'),
    print([PosList,D]),
    D1 is D-1,
    best(PosList, BestPos, Val, NodesList,D1).
minimax(Pos, BestPos, Val, [],_):-
    calcPoints(Pos,[P1,P2]),
    Val is P1-P2.

best([Pos], Pos, Val, NodesList,D):-
    minimax(Pos, _, Val, NodesList,D),    
    !.
best([Pos1|PosList], BestPos, BestVal, [BestPos|NodesList],D):-
    minimax(Pos1, _, Val1, NodesList1,D),
    best( PosList, Pos2, Val2, NodesList2),
    betterof(Pos1, Val1, Pos2, Val2, BestPos, BestVal,NodesList1, NodesList2, NodesList).

betterof(Pos0, Val0, Pos1, Val1, Pos0, Val0, NodesList0, NodesList1, NodesList0):-
    min_to_move(Pos0), Val0 > Val1, 
    !.
betterof(Pos0, Val0, Pos1, Val1, Pos0, Val0, NodesList0, NodesList1, NodesList0):-
    max_to_move(Pos0), Val0 < Val1, 
    !.
betterof(Pos0, Val0, Pos1, Val1, Pos1, Val1, NodesList0, NodesList1, NodesList1).

getStates(GameState,NewGameStates,D):-
    D>0,
    valid_moves(GameState,1,ListOfMoves),
    getValidMovesStates(ListOfMoves,GameState,NewGameStates).

getValidMovesStates([[Colour,X,Y]|Moves],GameState,NewGameStates):-
    ext_to_int(CP,LP,Y,X),
    move(GameState,target(Colour,X, Y, CP, LP),NewGameState),
    assert(move(GameState,[Colour,X,Y])),
    NewGameStates = [NewGameState|GameStates].
getValidMovesStates([],_,[]).