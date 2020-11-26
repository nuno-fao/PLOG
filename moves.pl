valid_moves(gameState(Board,UnusedPieces,_,_),Player,ListOfMoves):-
    check_line(Board,0,ValidPosList),
    checkForRed(UnusedPieces,Player,ValidPosList,RedMoveList),
    checkForBlue(UnusedPieces,Player,ValidPosList,BlueMoveList),
    append(RedMoveList,BlueMoveList,ListOfMoves).

checkForRed(UnusedPieces,Player,Valid,Altered):-
    verifyAvailablePiece(UnusedPieces,Player,'r'), !,
    map(Valid,addColorToPos,'r',Altered).
checkForRed(_UnusedPieces,_Player,_Valid,[]).
checkForBlue(UnusedPieces,Player,Valid,Altered):-
    verifyAvailablePiece(UnusedPieces,Player,'b'), !,
    map(Valid,addColorToPos,'b',Altered).
checkForBlue(_UnusedPieces,_Player,_Valid,[]).

map([], _, _, []).
map([X | List1], Transf, Colour, [Y | List2]) :-
    Func =.. [Transf, X, Colour, Y],
    Func,
    map(List1, Transf, Colour, List2).
addColorToPos(Move,Colour,MoveWithColor):-
    MoveWithColor = [Colour|Move].



%posição vazia -> válida -> adicionar à lista
check_pos(Line,P,[H|T],List) :-
    H = ' ',
    ext_to_int(Col,Ind,P,Line),
    verifyNotInVoid(Col,Ind),
    P1 is P + 1,
    !,
    check_pos(Line,P1,T,List1),
    Pos = [Line,P],
    append([Pos],List1,List).
    
%não vazia ou void -> segue em frente
check_pos(Line,P,[_H|T],List) :-
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

verifyAvailablePiece(unusedPieces(UnusedRed0,UnusedBlue0,_,_),0,Colour) :-
    verifyAvailableAux(UnusedRed0,UnusedBlue0,Colour).
verifyAvailablePiece(unusedPieces(_,_,UnusedRed1,UnusedBlue1),1,Colour) :-
    verifyAvailableAux(UnusedRed1,UnusedBlue1,Colour).
verifyAvailableAux(UnusedRed,_,'r'):-
    UnusedRed > 0.
verifyAvailableAux(_,UnusedBlue,'b'):-
    UnusedBlue > 0.

removeFromUnused(unusedPieces(UnusedRed0,UnusedBlue0,UnusedRed1,UnusedBlue1),0,Colour,NewUnused) :-
    removeUnusedAux(UnusedRed0,UnusedBlue0,Colour,NewUnusedRed,NewUnusedBlue),
    NewUnused =.. [unusedPieces,NewUnusedRed,NewUnusedBlue,UnusedRed1,UnusedBlue1].
removeFromUnused(unusedPieces(UnusedRed0,UnusedBlue0,UnusedRed1,UnusedBlue1),1,Colour,NewUnused) :-
    removeUnusedAux(UnusedRed1,UnusedBlue1,Colour,NewUnusedRed,NewUnusedBlue),
    NewUnused =.. [unusedPieces,UnusedRed0,UnusedBlue0,NewUnusedRed,NewUnusedBlue].
removeUnusedAux(UnusedRed,UnusedBlue,'r',NewUnusedRed,UnusedBlue):-
    NewUnusedRed is UnusedRed-1.
removeUnusedAux(UnusedRed,UnusedBlue,'b',UnusedRed,NewUnusedBlue):-
    NewUnusedBlue is UnusedBlue-1.


changeTurn(0,1).
changeTurn(1,0).

move(gameState(Board,UnusedPieces,OutPieces,Player),target(Colour,X, Y, ColumnP, LineP),NewGameState):-

    verifyAvailablePiece(UnusedPieces,Player,Colour),
    nth0(X,Board,Linha),
    replace_nth0(Linha,Y,' ',Colour,NewLinha),
    replace_nth0(Board,X,Linha,NewLinha,NewBoard),

    removeFromUnused(UnusedPieces,Player,Colour,NewUnusedPieces),


    %format("Point: ~p ~p ~n",[ColumnP,LineP]),
    moveUp(NewBoard,Colour,ColumnP,LineP,Board1),
    moveUpRight(Board1,Colour,ColumnP,LineP,Board2),
    moveUpLeft(Board2,Colour,ColumnP,LineP,Board3),
    moveDown(Board3,Colour,ColumnP,LineP,Board4),
    moveDownRight(Board4,Colour,ColumnP,LineP,Board5),
    moveDownLeft(Board5,Colour,ColumnP,LineP,Board6),

    %display_game(gameState(Board6,UnusedPieces,OutPieces,Player),Player),

    search_board(Board6,OutPieces,Board7,NewOutPieces,0,0),

    changeTurn(Player,NewPlayer),

    NewGameState =.. [gameState,Board7,NewUnusedPieces,NewOutPieces,NewPlayer].

replace_nth0(List, Index, OldElem, NewElem, NewList) :-
   % predicate works forward: Index,List -> OldElem, Transfer
   nth0(Index,List,OldElem,Transfer),
   % predicate works backwards: Index,NewElem,Transfer -> NewList
   nth0(Index,NewList,NewElem,Transfer).

%mexe uma peça de cor Color de (XI,YI) para (XF,YF) em valores externos
movePiece(Board,Color,XI,YI,XF,YF,NewBoard) :-
    ext_to_int(XI,YI,YY1,XX1),
    ext_to_int(XF,YF,YY2,XX2),
    %mete vazio na inicial
    nth0(XX1,Board,Linha),
    replace_nth0(Linha,YY1,Color,' ',NewLinha),
    replace_nth0(Board,XX1,Linha,NewLinha,BoardInt),

    %mete color no target 
    nth0(XX2,BoardInt,Linha1),
    replace_nth0(Linha1,YY2,' ',Color,NewLinha1),
    replace_nth0(BoardInt,XX2,Linha1,NewLinha1,NewBoard).


%Move a primeira peça acima
moveUp(Board, Color, XI, YI, NewBoard):-
    getUpPosition(XI,YI,XT,YT),    %obter posição imediatamente acima para começar a verificar
    checkUp(Board,XT,YT,ColumnO,LineO,PieceO),      %obter peça mais próxima, se não encontrar muda de instanciação
    %format("UP: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),      
    applyMoveUp(Board,Color,XI,YI,ColumnO,LineO,PieceO,NewBoard),   %peça encontrada agora falta movê-la
    !.
moveUp(Board,_,_,_,NewBoard):-
    NewBoard = Board.   %nada acontece, copia board e segue jogo
    %format("UP: NADA~n",[]).
applyMoveUp(Board,Color,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color \= ColorEncontrada, !,    %quando as peças são de cor diferente
    getUpPosition(XColocado,YColocado,XT,YT),       %obtem posição imediatamente acima da que foi colocada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).        %move a peça para a posição obtida no predicado em cima
applyMoveUp(Board,Color,_,_,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color = ColorEncontrada,    %quando as peças são de cor igual
    getUpPosition(XEncontrado,YEncontrado,XT,YT),   %obtem posição imediatamente acima da peça encontrada
    checkUp(Board,XT,YT,ColumnO,LineO,_),   %procura outra peça acima desta para colidir, se não houver passa à seguinte instanciação
    getDownPosition(ColumnO,LineO,TargetX,TargetY),     %obtem posição abaixo da nova encontrada, que é para lá onde se vai mover a primeira peça encontrada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,TargetX,TargetY,NewBoard),  %mover a peça
    !.
applyMoveUp(Board,_,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):- 
    getVoidUp(XColocado,YColocado,XT,YT),   %obtem a célula void encontrada na direção Up
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).    %move a peça para a zona void encontrada
getVoidUp(XI,YI,XV,YV):-    %obtem a célula void encontrada na direção Up
    verifyNotInVoid(XI,YI), %ainda não chegou ao void
    !,
    getUpPosition(XI,YI,X1,Y1),
    getVoidUp(X1,Y1,XV,YV).
getVoidUp(XI,YI,XV,YV):-    %chegou ao void
    XV = XI,
    YV = YI.

%Move a primeira peça up right
moveUpRight(Board, Color, XI, YI, NewBoard):-
    getUpRightPosition(XI,YI,XT,YT),    %obter posição imediatamente up right para começar a verificar
    checkUpRight(Board,XT,YT,ColumnO,LineO,PieceO),      %obter peça mais próxima, se não encontrar muda de instanciação
    %format("UP RIGHT: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),      
    applyMoveUpRight(Board,Color,XI,YI,ColumnO,LineO,PieceO,NewBoard),   %peça encontrada agora falta movê-la
    !.
moveUpRight(Board,_,_,_,NewBoard):-
    NewBoard = Board.       %nada acontece, copia board e segue jogo
    %format("UP RIGHT: NADA~n",[]).
applyMoveUpRight(Board,Color,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color \= ColorEncontrada, !,    %quando as peças são de cor diferente
    getUpRightPosition(XColocado,YColocado,XT,YT),       %obtem posição imediatamente up right da que foi colocada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).        %move a peça para a posição obtida no predicado em cima
applyMoveUpRight(Board,Color,_,_,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color = ColorEncontrada,    %quando as peças são de cor igual
    getUpRightPosition(XEncontrado,YEncontrado,XT,YT),   %obtem posição imediatamente up right da peça encontrada
    checkUpRight(Board,XT,YT,ColumnO,LineO,_),   %procura outra peça up right desta para colidir, se não houver passa à seguinte instanciação
    getDownLeftPosition(ColumnO,LineO,TargetX,TargetY),     %obtem posição down left da nova encontrada, que é para lá onde se vai mover a primeira peça encontrada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,TargetX,TargetY,NewBoard),  %mover a peça
    !.
applyMoveUpRight(Board,_,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):- 
    getVoidUpRight(XColocado,YColocado,XT,YT),   %obtem a célula void encontrada na direção Up Right
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).    %move a peça para a zona void encontrada
    getVoidUpRight(XI,YI,XV,YV):-    %obtem a célula void encontrada na direção Up Right
    verifyNotInVoid(XI,YI), %ainda não chegou ao void
    !,
    getUpRightPosition(XI,YI,X1,Y1),
    getVoidUpRight(X1,Y1,XV,YV).
getVoidUpRight(XI,YI,XV,YV):-    %chegou ao void
    XV = XI,
    YV = YI.

%Move a primeira peça up right
moveUpLeft(Board, Color, XI, YI, NewBoard):-
    getUpLeftPosition(XI,YI,XT,YT),    %obter posição imediatamente up left para começar a verificar
    checkUpLeft(Board,XT,YT,ColumnO,LineO,PieceO),      %obter peça mais próxima, se não encontrar muda de instanciação
    %format("UP LEFT: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),      
    applyMoveUpLeft(Board,Color,XI,YI,ColumnO,LineO,PieceO,NewBoard),   %peça encontrada agora falta movê-la
    !.
moveUpLeft(Board,_,_,_,NewBoard):-
    NewBoard = Board.       %nada acontece, copia board e segue jogo    
    %format("UP LEFT: NADA~n",[]).
applyMoveUpLeft(Board,Color,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color \= ColorEncontrada, !,    %quando as peças são de cor diferente
    getUpLeftPosition(XColocado,YColocado,XT,YT),       %obtem posição imediatamente up left da que foi colocada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).        %move a peça para a posição obtida no predicado em cima
applyMoveUpLeft(Board,Color,_,_,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color = ColorEncontrada,    %quando as peças são de cor igual
    getUpLeftPosition(XEncontrado,YEncontrado,XT,YT),   %obtem posição imediatamente up left da peça encontrada
    checkUpLeft(Board,XT,YT,ColumnO,LineO,_),   %procura outra peça up left desta para colidir, se não houver passa à seguinte instanciação
    getDownRightPosition(ColumnO,LineO,TargetX,TargetY),     %obtem posição down right da nova encontrada, que é para lá onde se vai mover a primeira peça encontrada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,TargetX,TargetY,NewBoard),  %mover a peça
    !.
applyMoveUpLeft(Board,_,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):- 
    getVoidUpLeft(XColocado,YColocado,XT,YT),   %obtem a célula void encontrada na direção Up left
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).    %move a peça para a zona void encontrada
    getVoidUpLeft(XI,YI,XV,YV):-    %obtem a célula void encontrada na direção Up left
    verifyNotInVoid(XI,YI), %ainda não chegou ao void
    !,
    getUpLeftPosition(XI,YI,X1,Y1),
    getVoidUpLeft(X1,Y1,XV,YV).
getVoidUpLeft(XI,YI,XV,YV):-    %chegou ao void
    XV = XI,
    YV = YI.

%Move a primeira peça para baixo
moveDown(Board, Color, XI, YI, NewBoard):-
    getDownPosition(XI,YI,XT,YT),    %obter posição imediatamente abaixo para começar a verificar
    checkDown(Board,XT,YT,ColumnO,LineO,PieceO),      %obter peça mais próxima, se não encontrar muda de instanciação
    %format("DOWN: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),      
    applyMoveDown(Board,Color,XI,YI,ColumnO,LineO,PieceO,NewBoard),   %peça encontrada agora falta movê-la
    !.
moveDown(Board,_,_,_,NewBoard):-
    NewBoard = Board.       %nada acontece, copia board e segue jogo    
    %format("DOWN: NADA~n",[]).
applyMoveDown(Board,Color,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color \= ColorEncontrada, !,    %quando as peças são de cor diferente
    getDownPosition(XColocado,YColocado,XT,YT),       %obtem posição imediatamente abaixo da que foi colocada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).        %move a peça para a posição obtida no predicado em cima
applyMoveDown(Board,Color,_,_,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color = ColorEncontrada,    %quando as peças são de cor igual
    getDownPosition(XEncontrado,YEncontrado,XT,YT),   %obtem posição imediatamente abaixo da peça encontrada
    checkDown(Board,XT,YT,ColumnO,LineO,_),   %procura outra peça abaixo desta para colidir, se não houver passa à seguinte instanciação
    getUpPosition(ColumnO,LineO,TargetX,TargetY),     %obtem posição acima da nova encontrada, que é para lá onde se vai mover a primeira peça encontrada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,TargetX,TargetY,NewBoard),  %mover a peça
    !.
applyMoveDown(Board,_,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):- 
    getVoidDown(XColocado,YColocado,XT,YT),   %obtem a célula void encontrada na direção down
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).    %move a peça para a zona void encontrada
    getVoidDown(XI,YI,XV,YV):-    %obtem a célula void encontrada na direção down
    verifyNotInVoid(XI,YI), %ainda não chegou ao void
    !,
    getDownPosition(XI,YI,X1,Y1),
    getVoidDown(X1,Y1,XV,YV).
getVoidDown(XI,YI,XV,YV):-    %chegou ao void
    XV = XI,
    YV = YI.

%Move a primeira peça down right
moveDownRight(Board, Color, XI, YI, NewBoard):-
    getDownRightPosition(XI,YI,XT,YT),    %obter posição imediatamente down right para começar a verificar
    checkDownRight(Board,XT,YT,ColumnO,LineO,PieceO),      %obter peça mais próxima, se não encontrar muda de instanciação
    %format("DOWN RIGHT: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),      
    applyMoveDownRight(Board,Color,XI,YI,ColumnO,LineO,PieceO,NewBoard),   %peça encontrada agora falta movê-la
    !.
moveDownRight(Board,_,_,_,NewBoard):-
    NewBoard = Board.       %nada acontece, copia board e segue jogo    
    %format("DOWN RIGHT: NADA~n",[]).
applyMoveDownRight(Board,Color,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color \= ColorEncontrada, !,    %quando as peças são de cor diferente
    getDownRightPosition(XColocado,YColocado,XT,YT),       %obtem posição imediatamente down right da que foi colocada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).        %move a peça para a posição obtida no predicado em cima
applyMoveDownRight(Board,Color,_,_,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color = ColorEncontrada,    %quando as peças são de cor igual
    getDownRightPosition(XEncontrado,YEncontrado,XT,YT),   %obtem posição imediatamente down right da peça encontrada
    checkDownRight(Board,XT,YT,ColumnO,LineO,_),   %procura outra peça down right desta para colidir, se não houver passa à seguinte instanciação
    getUpLeftPosition(ColumnO,LineO,TargetX,TargetY),     %obtem posição up left da nova encontrada, que é para lá onde se vai mover a primeira peça encontrada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,TargetX,TargetY,NewBoard),  %mover a peça
    !.
applyMoveDownRight(Board,_,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):- 
    getVoidDownRight(XColocado,YColocado,XT,YT),   %obtem a célula void encontrada na direção down right
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).    %move a peça para a zona void encontrada
getVoidDownRight(XI,YI,XV,YV):-    %obtem a célula void encontrada na direção down right
    verifyNotInVoid(XI,YI), %ainda não chegou ao void
    !,
    getDownRightPosition(XI,YI,X1,Y1),
    getVoidDownRight(X1,Y1,XV,YV).
getVoidDownRight(XI,YI,XV,YV):-    %chegou ao void
    XV = XI,
    YV = YI.

%Move a primeira peça down left
moveDownLeft(Board, Color, XI, YI, NewBoard):-
    getDownLeftPosition(XI,YI,XT,YT),    %obter posição imediatamente down right para começar a verificar
    checkDownLeft(Board,XT,YT,ColumnO,LineO,PieceO),      %obter peça mais próxima, se não encontrar muda de instanciação
    %format("DOWN LEFT: ~p ~p ~p ~n",[ColumnO,LineO,PieceO]),      
    applyMoveDownLeft(Board,Color,XI,YI,ColumnO,LineO,PieceO,NewBoard),   %peça encontrada agora falta movê-la
    !.
moveDownLeft(Board,_,_,_,NewBoard):-
    NewBoard = Board.       %nada acontece, copia board e segue jogo    
    %format("Down LEFT: NADA~n",[]).
applyMoveDownLeft(Board,Color,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color \= ColorEncontrada, !,    %quando as peças são de cor diferente
    getDownLeftPosition(XColocado,YColocado,XT,YT),       %obtem posição imediatamente down left da que foi colocada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).        %move a peça para a posição obtida no predicado em cima
applyMoveDownLeft(Board,Color,_,_,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color = ColorEncontrada,    %quando as peças são de cor igual
    getDownLeftPosition(XEncontrado,YEncontrado,XT,YT),   %obtem posição imediatamente down left da peça encontrada
    checkDownLeft(Board,XT,YT,ColumnO,LineO,_),   %procura outra peça down left desta para colidir, se não houver passa à seguinte instanciação
    getUpRightPosition(ColumnO,LineO,TargetX,TargetY),     %obtem posição up right da nova encontrada, que é para lá onde se vai mover a primeira peça encontrada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,TargetX,TargetY,NewBoard),  %mover a peça
    !.
applyMoveDownLeft(Board,_,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):- 
    getVoidDownLeft(XColocado,YColocado,XT,YT),   %obtem a célula void encontrada na direção down left
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).    %move a peça para a zona void encontrada
getVoidDownLeft(XI,YI,XV,YV):-    %obtem a célula void encontrada na direção down left
    verifyNotInVoid(XI,YI), %ainda não chegou ao void
    !,
    getDownLeftPosition(XI,YI,X1,Y1),
    getVoidDownLeft(X1,Y1,XV,YV).
getVoidDownLeft(XI,YI,XV,YV):-    %chegou ao void
    XV = XI,
    YV = YI.

%Procura a primeira peça diretamente abaixo
checkDown(Board, XI, YI, XO, YO, PieceO):-
    verifyInBoard(XI,YI),
    ext_to_int(XI,YI,XX,YY),
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
    ext_to_int(XI,YI,XX,YY),
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
    ext_to_int(XI,YI,XX,YY),
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
    ext_to_int(XI,YI,XX,YY),
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
    ext_to_int(XI,YI,XX,YY),
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
    ext_to_int(XI,YI,XX,YY),
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
    XI > 3,
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


iterate_col(Line,InitC,[_,Y,Colour]):-
    nth0(InitC,Line,Pos),
    Pos \= ' ',
    !,
    Y = InitC,
    Colour = Pos.
iterate_col(Line,InitC,[X,Y,Colour]):-
    nth0(InitC,Line,_),
    C is InitC + 1,
    !,
    iterate_col(Line,C,[X,Y,Colour]).
iterate_col(_,_,[_,Y,Colour]):-
    !,
    Y = 'X',
    Colour = 'X'.

iterate_line(Board,InitL,InitC,Out):-
    InitL < 13,
    nth0(InitL,Board,Line),
    iterate_col(Line,InitC,[_,Y,Colour]),
    Y \= 'X',
    !,
    Out = [InitL,Y,Colour].
iterate_line(Board,InitL,_,Out):-
    InitL < 13,
    L is InitL + 1,
    !,
    iterate_line(Board,L,0,Out).
iterate_line(_,_,_,[X,Y,Colour]):-
    !,
    X = 'X',
    Y = 'X',
    Colour = 'X'.

getColour(Board,X,Y,Colour):-
    nth0(X,Board,Line),
    nth0(Y,Line,C),
    !,
    Colour = C.

getColour(_,_,_,Colour):-
    Colour = ' '.

search_near(Board,X,Y,Colour):-
    assert(processed([X,Y])),
    assert(sequence(X,Y,Colour)),
    ext_to_int(C,L,Y,X),
    getUpPosition(C,L,UPC,UPL),
    add_to_list(Board,UPC,UPL,Colour),
    getDownPosition(C,L,DC,DL),
    add_to_list(Board,DC,DL,Colour),
    getUpLeftPosition(C,L,ULC,ULL),
    add_to_list(Board,ULC,ULL,Colour),
    getUpRightPosition(C,L,URC,URL),
    add_to_list(Board,URC,URL,Colour),
    getDownRightPosition(C,L,DRC,DRL),
    add_to_list(Board,DRC,DRL,Colour),
    getDownLeftPosition(C,L,DLC,DLL),
    add_to_list(Board,DLC,DLL,Colour).


add_to_list(Board,C,L,Colour):-
    verifyInBoard(C,L),
    ext_to_int(C,L,Y,X),
    \+retract(processed([X,Y])),
    assert(processed([X,Y])),
    getColour(Board,X,Y,NewColour),
    NewColour = Colour,
    search_near(Board,X,Y,Colour).

add_to_list(_,_,_,_).



search_board(Board,OutPieces,NewBoard,NewOutPieces,InitL,InitC):-
    iterate_line(Board,InitL,InitC,Out),
    [X,Y,Colour] = Out,
    X \= 'X',
    Y2 is Y + 1,
    !,
    retractall(sequence(_,_,_)),
    retractall(processed(_)),
    assert(sequence(0,0,0)),
    search_near(Board,X,Y,Colour),
    retract(sequence(0,0,0)),
    setof([III,VVV,CCC],sequence(III,VVV,CCC),Bolacha),
    removePieces(Board,OutPieces,Bolacha,NewBoardA,NewOPieces),
    search_board(NewBoardA,NewOPieces,NewBoard,NewOutPieces,X,Y2).

search_board(Board,OutPieces,NewBoard,NewOutPieces,_,_):-
    NewBoard = Board,
    NewOutPieces = OutPieces.

removePieces(Board,OutPieces,Bolacha,NewBoard,NewOutPieces):-
    length(Bolacha,Tam),
    Tam > 3,
    %print('Removing Whiskas saquetas!\n'),
    %read(_),
    removeFromList(Board,OutPieces,NewBoard,Bolacha,NewOutPieces).
removePieces(Board,OutPieces,_,NewBoard,NewOutPieces):-
    NewBoard = Board,
    NewOutPieces = OutPieces.

removeFromList(Board,OutPieces,NewBoard,[[X,Y,Colour]|T],NewOutPieces):-
    nth0(X,Board,Linha),
    replace_nth0(Linha,Y,Colour,' ',NewLinha),
    replace_nth0(Board,X,Linha,NewLinha,NewBoardA),

    updatePieces(OutPieces,NewOPieces,X,Y,Colour),

    removeFromList(NewBoardA,NewOPieces,NewBoard,T,NewOutPieces).
removeFromList(Board,OutPieces,NewBoard,_,NewOutPieces):-
    NewBoard = Board,
    NewOutPieces = OutPieces.

updatePieces(outPieces(RedPointPiece,BluePointPiece,VoidPieces1,VoidPieces2),NewOutPieces,X,Y,Colour):-
    Colour = 'r',
    %print([X,Y]),
    ext_to_int(C,L,Y,X),
    verifyNotInVoid(C,L),
    Out is RedPointPiece +1,
	NewOutPieces =.. [outPieces,Out,BluePointPiece,VoidPieces1,VoidPieces2].

updatePieces(outPieces(RedPointPiece,BluePointPiece,VoidPieces1,VoidPieces2),NewOutPieces,_,_,Colour):-
    Colour = 'r',
    Out is VoidPieces1 +1,   
	NewOutPieces =.. [outPieces,RedPointPiece,BluePointPiece,Out,VoidPieces2].

updatePieces(outPieces(RedPointPiece,BluePointPiece,VoidPieces1,VoidPieces2),NewOutPieces,X,Y,Colour):-
    Colour = 'b',
    ext_to_int(C,L,Y,X),
    verifyNotInVoid(C,L),
    Out is BluePointPiece +1,    
	NewOutPieces =.. [outPieces,RedPointPiece,Out,VoidPieces1,VoidPieces2].

updatePieces(outPieces(RedPointPiece,BluePointPiece,VoidPieces1,VoidPieces2),NewOutPieces,_,_,Colour):-
    Colour = 'b',
    Out is VoidPieces2 +1,    
	NewOutPieces =.. [outPieces,RedPointPiece,BluePointPiece,VoidPieces1,Out].