ai(GameState,OutGameState):-
    getStates(GameState,NewGameStates),
    getMaxSons(NewGameStates,-99999,GameState,OutGameState,_).
getMaxSons([GameState|Rest],InValue,InGameState,OutGameState,OutValue):-
    calcPoints(GameState,[P1,P2]),
    NValue is P2 - P1,
    getmax(NValue,GameState,InValue,InGameState,OValue,OGameState),
    getMaxSons(Rest,OValue,OGameState,OutGameState,OutValue).
getMaxSons([GameState],InValue,InGameState,OutGameState,OutValue):-
    calcPoints(GameState,[P1,P2]),
    NValue is P2-P1,
    getmax(NValue,GameState,InValue,InGameState,OutValue,OutGameState).
    
getmax(Value1,State1,Value2,State2,OutValue,OutState):-
    Value1 > Value2,
    OutValue = Value1,
    OutState = State1,
    !.

getmax(Value1,State1,Value2,State2,OutValue,OutState):-
    Value1 < Value2,
    OutValue = Value2,
    OutState = State2,
    !.

getmax(Value1,State1,Value1,_,Value1,State1).




getStates(GameState,NewGameStates):-
    valid_moves(GameState,1,ListOfMoves),
    ListOfMoves \= [],
    getValidMovesStates(ListOfMoves,GameState,NewGameStates).

getValidMovesStates([[Colour,X,Y]|Moves],GameState,NewGameStates):-
    ext_to_int(CP,LP,Y,X),
    move(GameState,target(Colour,X, Y, CP, LP),NewGameState),
    assert(moves(NewGameState,[Colour,X,Y])),
    getValidMovesStates(Moves,GameState,GameStates),
    NewGameStates = [NewGameState|GameStates].
getValidMovesStates([],_,[]).