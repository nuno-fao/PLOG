minimax(Pos, BestPos, Val, NodesList):-    
    retract(depth(Pos,DD)),
    assert(depth(Pos,DD)),
    print(DD),
    getStates(Pos,PosList), 
    !,
    best(PosList, BestPos, Val, NodesList).
minimax(Pos, BestPos, Val, []):-
    calcPoints(Pos, [P1,P2]),
    Val is P1 - P2.

best([Pos], Pos, Val, NodesList):-
    minimax(Pos, _, Val, NodesList),    
    !.
best([Pos1|PosList], BestPos, BestVal, [BestPos|NodesList]):-
    minimax(Pos1, _, Val1, NodesList1),
    best(PosList, Pos2, Val2, NodesList2),
    betterof(Pos1, Val1, Pos2, Val2, BestPos, BestVal,NodesList1, NodesList2, NodesList).

betterof(Pos0, Val0, Pos1, Val1, Pos0, Val0, NodesList0, NodesList1, NodesList0):-
    [Board,_,_,Player] = Pos0,
    min_to_move(Pos0), Val0 > Val1, 
    !.
betterof(Pos0, Val0, Pos1, Val1, Pos0, Val0, NodesList0, NodesList1, NodesList0):-
    max_to_move(Pos0), Val0 < Val1, 
    !.
betterof(Pos0, Val0, Pos1, Val1, Pos1, Val1, NodesList0, NodesList1, NodesList1).

