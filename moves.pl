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
    moveDir(NewBoard,checkUp,getUpPosition,getDownPosition,Colour,ColumnP,LineP,Board1),
    moveDir(Board1,checkUpRight,getUpRightPosition,getDownLeftPosition,Colour,ColumnP,LineP,Board2),
    moveDir(Board2,checkUpLeft,getUpLeftPosition,getDownRightPosition,Colour,ColumnP,LineP,Board3),
    moveDir(Board3,checkDown,getDownPosition,getUpPosition,Colour,ColumnP,LineP,Board4),
    moveDir(Board4,checkDownLeft,getDownLeftPosition,getUpRightPosition,Colour,ColumnP,LineP,Board5),
    moveDir(Board5,checkDownRight,getDownRightPosition,getUpLeftPosition,Colour,ColumnP,LineP,Board6),
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
moveDir(Board, CheckDirFunc, GetDirPosFunc, GetOposDirFunc, Color, XI, YI, NewBoard):-
    GetDir =.. [GetDirPosFunc,XI,YI,XT,YT], GetDir, %obter posição imediatamente a seguir na direção pretendida para começar a verificar
    CheckDir =.. [CheckDirFunc,Board,XT,YT,ColumnO,LineO,PieceO], CheckDir,  %obter peça mais próxima, se não encontrar muda de instanciação
    applyMoveDir(Board, CheckDirFunc, GetDirPosFunc, GetOposDirFunc, Color,XI,YI,ColumnO,LineO,PieceO,NewBoard),   %peça encontrada agora falta movê-la
    !.
moveDir(Board,_,_,_,_,_,_,NewBoard):-
    NewBoard = Board.   %nada acontece, copia board e segue jogo
applyMoveDir(Board,CheckDirFunc, GetDirPosFunc, GetOposDirFunc,Color,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color \= ColorEncontrada, !,    %quando as peças são de cor diferente
    GetDir =.. [GetDirPosFunc,XColocado,YColocado,XT,YT], GetDir, %obtem posição imediatamente a seguir na direção da que foi colocada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).        %move a peça para a posição obtida no predicado em cima
applyMoveDir(Board,CheckDirFunc, GetDirPosFunc, GetOposDirFunc,Color,_,_,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color = ColorEncontrada,    %quando as peças são de cor igual
    GetDir =.. [GetDirPosFunc,XEncontrado,YEncontrado,XT,YT], GetDir, %obtem posição imediatamente imediatamente a seguir da peça encontrada na direção pretendida 
    CheckDir =.. [CheckDirFunc,Board,XT,YT,ColumnO,LineO,_], CheckDir, !, %procura outra peça na mesma direção para colidir, se não houver passa à seguinte instanciação
    GetOposDir =.. [GetOposDirFunc,ColumnO,LineO,TargetX,TargetY], GetOposDir,  %obtem posição anterior à encontrada, que é para lá onde se vai mover a peça inicialmente encontrada
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,TargetX,TargetY,NewBoard). %mover a peça
applyMoveDir(Board,CheckDirFunc, GetDirPosFunc, GetOposDirFunc,_,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):- 
    getVoidDir(GetDirPosFunc,XColocado,YColocado,XT,YT),   %obtem a célula void encontrada na direção pretendida
    movePiece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).    %move a peça para a zona void encontrada
getVoidDir(GetDirPosFunc,XI,YI,XV,YV):-    %obtem a célula void encontrada na direção pretendida
    verifyNotInVoid(XI,YI), !, %ainda não chegou ao void
    GetDir =.. [GetDirPosFunc,XI,YI,X1,Y1], GetDir,
    getVoidDir(GetDirPosFunc,X1,Y1,XV,YV).
getVoidDir(GetDirPosFunc,XI,YI,XV,YV):-    %chegou ao void
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