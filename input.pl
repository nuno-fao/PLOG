move(gameState(Board,UnusedPieces,OutPieces,Player),target(Colour,X,Y),NewGameState):-
    check_empty_pos(X,Y,Result),
    Result = ' ',
    
    nth0(X,Board,Linha),
    replace_nth0(Linha,Y,' ',Colour,NewLinha),
    replace_nth0(Board,X,Linha,NewLinha,NewBoard),
    NewGameState =.. [gameState,NewBoard,UnusedPieces,OutPieces,Player],
    !.

check_empty_pos(X,Y,Result):-
    nth0(X,Board,Linha),
    nth0(Y,Linha,Result).

replace_nth0(List, Index, OldElem, NewElem, NewList) :-
   % predicate works forward: Index,List -> OldElem, Transfer
   nth0(Index,List,OldElem,Transfer),
   % predicate works backwards: Index,NewElem,Transfer -> NewList
   nth0(Index,NewList,NewElem,Transfer).
