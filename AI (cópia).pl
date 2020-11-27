minimax(GameState, D , Mov):-
    SD is D - 1,
    getStates(GameState,Lista),
    maxOfSons(Lista,SD,-9999,[],Value,Mov).

minimax(GameState, D, Max , Value, Mov):-
    D = 0,
    calcPoints(GameState,[P1,P2]),
    Mov = GameState,
    Value is P2-P1.

minimax(GameState, D, Max ,Value, Mov):-
    D > 0,
    Max = false,
    SD is D - 1,
    getStates(GameState,Lista),
    Mov = GameState,
    minOfSons(Lista,SD,99999,[],Value,P).

minimax(GameState, D, Max ,Value, Mov):-
    D > 0,
    Max = true,
    SD is D - 1,
    getStates(GameState,Lista),
    Mov = GameState,
    maxOfSons(Lista,SD,-9999,[],Value,P).

minOfSons([Head|Rest],D,Value,Mov,OValue,OMov):-
    minimax(Head,D,true,V,M),
    setMin(Value,Mov,V,M,O1,M1),
    minOfSons(Rest,D,O1,M1,OV2,OM2),
    setMin(OV2,OM2,O1,M1,OValue,OMov).

minOfSons([Head],D,Value,Mov,OValue,OMov):-
    minimax(Head,D,true,V,M),
    setMin(Value,Mov,V,M,OValue,OMov).
setMin(V1,M1,V2,M2,OV,OM):-
    V1 < V2,
    OM = M1,
    OV = V1.
setMin(V1,M1,V2,M2,OV,OM):-
    V1 > V2,
    OM = M2,
    OV = V2.
setMin(V1,M1,V2,M2,V1,M1).

maxOfSons([Head|Rest],D,Value,Mov,OValue,OMov):-
    minimax(Head,D,false,V,M),
    setMax(Value,Mov,V,M,O1,M1),
    maxOfSons(Rest,D,O1,M1,OV2,OM2),
    setMax(OV2,OM2,O1,M1,OValue,OMov).

maxOfSons([Head],D,Value,Mov,OValue,OMov):-
    minimax(Head,D,false,V,M),
    setMax(Value,Mov,V,M,OValue,OMov).
setMax(V1,M1,V2,M2,OV,OM):-
    V1 > V2,
    OM = M1,
    OV = V1.
setMax(V1,M1,V2,M2,OV,OM):-
    V1 < V2,
    OM = M2,
    OV = V2.
setMax(V1,M1,V2,M2,V1,M1).

getStates(GameState,NewGameStates):-
    valid_moves(GameState,1,ListOfMoves),
    length(ListOfMoves,Tam),
    ListOfMoves \= [],
    getValidMovesStates(ListOfMoves,GameState,NewGameStates).

getValidMovesStates([[Colour,X,Y]|Moves],GameState,NewGameStates):-
    ext_to_int(CP,LP,Y,X),
    move(GameState,target(Colour,X, Y, CP, LP),NewGameState),
    assert(moves(GameState,[Colour,X,Y])),
    getValidMovesStates(Moves,GameState,GameStates),
    NewGameStates = [NewGameState|GameStates].
getValidMovesStates([],_,[]).