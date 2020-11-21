valid_moves(gameState(Board,_,_,_),_,ListOfMoves):-
    check_line(Board,0,ListOfMoves).


%posição vazia -> válida -> adicionar à lista
check_pos(Line,P,[H|T],List) :-
    H = ' ',
    P1 is P + 1,
    !,
    check_pos(Line,P1,T,List1),
    Pos =.. [pos,Line,P],
    append([Pos],List1,List).
    
%não vazio -> segue em frente
check_pos(Line,P,[H|T],List) :-
    H \= ' ',
    P1 is P + 1,
    !,
    check_pos(Line,P1,T,List).

%lista vazia -> fim da coluna
check_pos(_,_,_,List):-
    List = [],
    !.

%obter linhas e colunas disponiveis (valor interno)
check_line([H|T],Row,List) :-
    check_pos(Row,0,H,List1),
    R1 is Row + 1,
    check_line(T,R1,List2),
    append(List1,List2,List).

%acabou
check_line(_,_,List) :-
    List = [],
    !.


get_col(Line,Col,Out) :-
    (Col = 2 ; 
    Col = 1 ; 
    ((Col = 3 ; Col = 4), Line = 1) ; 
    (Col = 3 , Line = 6) ; 
    (Col = 4 , Line = 7)),
    Out is 0,
    !.

get_col(Line,Col,Out) :-
    (Col = 3 ; 
    Col = 4 ; 
    Col = 5, (Line=1; Line=6)),
    Out is 1,
    !.

get_col(_,Col,Out) :-
    (Col = 6; Col = 5),
    Out is 2,
    !.

get_col(_,Col,Out) :-
    Col = 7,
    Out is 3,
    !.

get_line(Line,Col,Out) :-
    Col < 5,
    Aux1 is Line - 1,
    Aux2 is 2*Aux1,
    Dif is 4 - Col,
    Out is Aux2 + Dif,
    !.

get_line(Line,Col,Out) :- 
    Aux1 is Line - 1,
    Aux2 is 2*Aux1,
    Dif is mod(Col,4),
    Out is Aux2 + Dif,
    !.

verifyNotInVoid(Col,Line):-
    Col > 1,
    Col < 7,
    Line > 1,
    Line < 7,
    (Col = 4 ; ((Col = 2; Col = 6), Line < 5 ); ((Col = 3; Col = 5), Line < 6)).


verifyInBoard(Col,Line):-
    Col > 0,
    Col < 8,
    Line > 0,
    Line < 8,
    (Col = 4 ; ((Col = 2; Col = 6), Line < 6 ); ((Col = 3; Col = 5), Line < 7)).

change_to_internal(Col,Line,NewCol,NewLine) :-
    get_col(Line,Col,NewCol),
    get_line(Line,Col,NewLine).
    %format("Linha ~p Coluna ~p ~n",[NewLine,NewCol]).

move(gameState(Board,UnusedPieces,OutPieces,Player),target(Colour,X, Y, ColumnP, LineP),NewGameState):-
    nth0(X,Board,Linha),
    replace_nth0(Linha,Y,' ',Colour,NewLinha),
    replace_nth0(Board,X,Linha,NewLinha,NewBoard),

    format("Point: ~p ~p ~n",[ColumnP,LineP]),
    moveUp(Board,ColumnP,LineP),
    moveUpRight(Board,ColumnP,LineP),
    moveUpLeft(Board,ColumnP,LineP),
    moveDown(Board,ColumnP,LineP),
    moveDownRight(Board,ColumnP,LineP),
    moveDownLeft(Board,ColumnP,LineP),

    NewGameState =.. [gameState,NewBoard,UnusedPieces,OutPieces,Player],
    !.

replace_nth0(List, Index, OldElem, NewElem, NewList) :-
   % predicate works forward: Index,List -> OldElem, Transfer
   nth0(Index,List,OldElem,Transfer),
   % predicate works backwards: Index,NewElem,Transfer -> NewList
   nth0(Index,NewList,NewElem,Transfer).

%mexe uma peça de cor Color de (XI,YI) para (XF,YF) em valores internos
movePiece(Board,Color,XI,YI,XF,YF,NewBoard) :-
    %mete vazio na inicial
    nth0(XI,Board,Linha),
    replace_nth0(Linha,YI,Color,' ',NewLinha),
    replace_nth0(Board,XI,Linha,NewLinha,BoardInt),

    %mete color no target 
    nth0(XF,BoardInt,Linha1),
    replace_nth0(Linha1,YF,' ',Color,NewLinha1),
    replace_nth0(BoardInt,XF,Linha1,NewLinha1,NewBoard).



moveUp(Board, XI, YI):-
    checkUp(Board,XI,YI,ColumnO,LineO,PieceO),
    format("UP: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),
    !.
moveUp(_,_,_):-
    format("UP: NADA~n",[]).


moveUpRight(Board, XI, YI):-
    checkUpRight(Board,XI,YI,ColumnO,LineO,PieceO),
    format("UP RIGHT: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),
    !.
moveUpRight(_,_,_):-
    format("UP RIGHT: NADA~n",[]).


moveUpLeft(Board, XI, YI):-
    checkUpLeft(Board,XI,YI,ColumnO,LineO,PieceO),
    format("UP LEFT: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),
    !.
moveUpLeft(_,_,_):-
    format("UP LEFT: NADA~n",[]).


moveDown(Board, XI, YI):-
    checkDown(Board,XI,YI,ColumnO,LineO,PieceO),
    format("DOWN: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),
    !.
moveDown(_,_,_):-
    format("DOWN: NADA~n",[]).


moveDownRight(Board, XI, YI):-
    checkDownRight(Board,XI,YI,ColumnO,LineO,PieceO),
    format("DOWN RIGHT: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),
    !.
moveDownRight(_,_,_):-
    format("DOWN RIGHT: NADA~n",[]).


moveDownLeft(Board, XI, YI):-
    checkDownLeft(Board,XI,YI,ColumnO,LineO,PieceO),
    format("Down LEFT: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),
    !.
moveDownLeft(_,_,_):-
    format("Down LEFT: NADA~n",[]).

%Procura a primeira peça diretamente abaixo
checkDown(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    change_to_internal(XI,YI,XX,YY),
    nth0(YY,Board,Linha),
    nth0(XX,Linha,Piece),
    Piece \= ' ',
    PieceO = Piece,
    XO is XI,
    YO is YI,
    !.
checkDown(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    getDownPosition(XI,YI,X,Y),
    !,
    checkDown(Board,X,Y,XO,YO,PieceO).

%Procura a primeira peça down left
checkDownLeft(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    change_to_internal(XI,YI,XX,YY),
    nth0(YY,Board,Linha),
    nth0(XX,Linha,Piece),
    Piece \= ' ',
    PieceO = Piece,
    XO is XI,
    YO is YI,
    !.
checkDownLeft(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    getDownLeftPosition(XI,YI,X,Y),
    !,
    checkDownLeft(Board,X,Y,XO,YO,PieceO).

%Procura a primeira peça down right
checkDownRight(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    change_to_internal(XI,YI,XX,YY),
    nth0(YY,Board,Linha),
    nth0(XX,Linha,Piece),
    Piece \= ' ',
    PieceO = Piece,
    XO is XI,
    YO is YI,
    !.
checkDownRight(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    getDownRightPosition(XI,YI,X,Y),
    !,
    checkDownRight(Board,X,Y,XO,YO,PieceO).

%Procura a primeira peça diretamente acima
checkUp(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    change_to_internal(XI,YI,XX,YY),
    nth0(YY,Board,Linha),
    nth0(XX,Linha,Piece),
    Piece \= ' ',
    PieceO = Piece,
    XO is XI,
    YO is YI,
    !.
checkUp(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    getUpPosition(XI,YI,X,Y),
    !,
    checkUp(Board,X,Y,XO,YO,PieceO).

%Procura a primeira peça up left
checkUpLeft(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    change_to_internal(XI,YI,XX,YY),
    nth0(YY,Board,Linha),
    nth0(XX,Linha,Piece),
    Piece \= ' ',
    PieceO = Piece,
    XO is XI,
    YO is YI,
    !.
checkUpLeft(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    getUpLeftPosition(XI,YI,X,Y),
    !,
    checkUpLeft(Board,X,Y,XO,YO,PieceO).

%Procura a primeira peça up right
checkUpRight(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    change_to_internal(XI,YI,XX,YY),
    nth0(YY,Board,Linha),
    nth0(XX,Linha,Piece),
    Piece \= ' ',
    PieceO = Piece,
    XO is XI,
    YO is YI,
    !.
checkUpRight(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    getUpRightPosition(XI,YI,X,Y),
    !,
    checkUpRight(Board,X,Y,XO,YO,PieceO).


getUpPosition(XI,YI,XO,YO):-
    XO is XI,
    YO is YI - 1.

getDownPosition(XI,YI,XO,YO):-
    XO is XI,
    YO is YI + 1.

getUpRightPosition(XI,YI,XO,YO):-
    XI < 4,
    XO is XI + 1,
    YO is YI.
getUpRightPosition(XI,YI,XO,YO):-
    XI > 3,
    XO is XI + 1,
    YO is YI - 1.

getUpLeftPosition(XI,YI,XO,YO):-
    XI > 4,
    XO is XI - 1,
    YO is YI.
getUpLeftPosition(XI,YI,XO,YO):-
    XI < 5,
    XO is XI - 1,
    YO is YI - 1.

getDownRightPosition(XI,YI,XO,YO):-
    XI < 4,
    XO is XI + 1,
    YO is YI +1.
getDownRightPosition(XI,YI,XO,YO):-
    YI > 3,
    XO is XI + 1,
    YO is YI.

getDownLeftPosition(XI,YI,XO,YO):-
    XI > 4,
    XO is XI - 1,
    YO is YI + 1.
getDownLeftPosition(XI,YI,XO,YO):-
    XI < 5,
    XO is XI - 1,
    YO is YI.