valid_moves(gameState(Board,UnusedPieces,_,_),Player,ListOfMoves):-
    check_line(Board,0,ValidPosList),
    check_for_red(UnusedPieces,Player,ValidPosList,RedMoveList),
    check_for_blue(UnusedPieces,Player,ValidPosList,BlueMoveList),
    append(RedMoveList,BlueMoveList,List),
    random_permutation(List,ListOfMoves).

check_for_red(UnusedPieces,Player,Valid,Altered):-
    verify_available_piece(UnusedPieces,Player,'r'), !,
    map(Valid,add_colour_to_pos,'r',Altered).
check_for_red(_UnusedPieces,_Player,_Valid,[]).
check_for_blue(UnusedPieces,Player,Valid,Altered):-
    verify_available_piece(UnusedPieces,Player,'b'), !,
    map(Valid,add_colour_to_pos,'b',Altered).
check_for_blue(_UnusedPieces,_Player,_Valid,[]).

map([], _, _, []).
map([X | List1], Transf, Colour, [Y | List2]) :-
    Func =.. [Transf, X, Colour, Y],
    Func,
    map(List1, Transf, Colour, List2).
add_colour_to_pos(Move,Colour,MoveWithColour):-
    MoveWithColour = [Colour|Move].

%posição vazia -> válida -> adicionar à lista
check_pos(Line,P,[H|T],List) :-
    H = ' ',
    ext_to_int(Col,Ind,P,Line),
    verify_not_in_void(Col,Ind),
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
    !,
    check_line(T,R1,List2),
    append(List1,List2,List).

%acabou
check_line(_,_,List) :-
    List = [],
    !.

verify_available_piece(unusedPieces(UnusedRed0,UnusedBlue0,_,_),0,Colour) :-
    verify_available_aux(UnusedRed0,UnusedBlue0,Colour).
verify_available_piece(unusedPieces(_,_,UnusedRed1,UnusedBlue1),1,Colour) :-
    verify_available_aux(UnusedRed1,UnusedBlue1,Colour).
verify_available_aux(UnusedRed,_,'r'):-
    UnusedRed > 0.
verify_available_aux(_,UnusedBlue,'b'):-
    UnusedBlue > 0.

remove_from_unused(unusedPieces(UnusedRed0,UnusedBlue0,UnusedRed1,UnusedBlue1),0,Colour,NewUnused) :-
    remove_unused_aux(UnusedRed0,UnusedBlue0,Colour,NewUnusedRed,NewUnusedBlue),
    NewUnused =.. [unusedPieces,NewUnusedRed,NewUnusedBlue,UnusedRed1,UnusedBlue1].
remove_from_unused(unusedPieces(UnusedRed0,UnusedBlue0,UnusedRed1,UnusedBlue1),1,Colour,NewUnused) :-
    remove_unused_aux(UnusedRed1,UnusedBlue1,Colour,NewUnusedRed,NewUnusedBlue),
    NewUnused =.. [unusedPieces,UnusedRed0,UnusedBlue0,NewUnusedRed,NewUnusedBlue].
remove_unused_aux(UnusedRed,UnusedBlue,'r',NewUnusedRed,UnusedBlue):-
    NewUnusedRed is UnusedRed-1.
remove_unused_aux(UnusedRed,UnusedBlue,'b',UnusedRed,NewUnusedBlue):-
    NewUnusedBlue is UnusedBlue-1.


change_turn(0,1).
change_turn(1,0).

move(gameState(Board,UnusedPieces,OutPieces,Player),target(Colour,X, Y, ColumnP, LineP),NewGameState):-

    verify_available_piece(UnusedPieces,Player,Colour),
    nth0(X,Board,Linha),
    replace_nth0(Linha,Y,' ',Colour,NewLinha),
    replace_nth0(Board,X,Linha,NewLinha,NewBoard),
    verify_not_in_void(ColumnP, LineP),
    

    remove_from_unused(UnusedPieces,Player,Colour,NewUnusedPieces),

    %format("Point: ~p ~p ~n",[ColumnP,LineP]),
    move_dir(NewBoard,get_up_position,get_down_position,Colour,ColumnP,LineP,Board1),
    move_dir(Board1,get_up_right_position,get_down_left_position,Colour,ColumnP,LineP,Board2),
    move_dir(Board2,get_up_left_position,get_down_right_position,Colour,ColumnP,LineP,Board3),
    move_dir(Board3,get_down_position,get_up_position,Colour,ColumnP,LineP,Board4),
    move_dir(Board4,get_down_left_position,get_up_right_position,Colour,ColumnP,LineP,Board5),
    move_dir(Board5,get_down_right_position,get_up_left_position,Colour,ColumnP,LineP,Board6),
    %display_game(gameState(Board6,UnusedPieces,OutPieces,Player),Player),

    search_board(Board6,OutPieces,Board7,NewOutPieces,0,0),

    change_turn(Player,NewPlayer),

    NewGameState =.. [gameState,Board7,NewUnusedPieces,NewOutPieces,NewPlayer].

replace_nth0(List, Index, OldElem, NewElem, NewList) :-
   % predicate works forward: Index,List -> OldElem, Transfer
   nth0(Index,List,OldElem,Transfer),
   % predicate works backwards: Index,NewElem,Transfer -> NewList
   nth0(Index,NewList,NewElem,Transfer).

%mexe uma peça de cor Colour de (XI,YI) para (XF,YF) em valores externos
move_piece(Board,Colour,XI,YI,XF,YF,NewBoard) :-
    ext_to_int(XI,YI,YY1,XX1),
    ext_to_int(XF,YF,YY2,XX2),
    %mete vazio na inicial
    nth0(XX1,Board,Linha),
    replace_nth0(Linha,YY1,Colour,' ',NewLinha),
    replace_nth0(Board,XX1,Linha,NewLinha,BoardInt),

    %mete colour no target 
    nth0(XX2,BoardInt,Linha1),
    replace_nth0(Linha1,YY2,' ',Colour,NewLinha1),
    replace_nth0(BoardInt,XX2,Linha1,NewLinha1,NewBoard).



%Move a primeira peça acima
move_dir(Board, GetDirPosFunc, GetOposDirFunc, Color, XI, YI, NewBoard):-
    GetDir =.. [GetDirPosFunc,XI,YI,XT,YT], GetDir, %obter posição imediatamente a seguir na direção pretendida para começar a verificar
    check_dir(Board,GetDirPosFunc,XT,YT,ColumnO,LineO,PieceO),%obter peça mais próxima, se não encontrar muda de instanciação
    apply_move_dir(Board, GetDirPosFunc, GetOposDirFunc, Color,XI,YI,ColumnO,LineO,PieceO,NewBoard),   %peça encontrada agora falta movê-la
    !.
move_dir(Board,_,_,_,_,_,NewBoard):-
    NewBoard = Board.   %nada acontece, copia board e segue jogo
apply_move_dir(Board, GetDirPosFunc, _GetOposDirFunc,Color,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color \= ColorEncontrada, !,    %quando as peças são de cor diferente
    GetDir =.. [GetDirPosFunc,XColocado,YColocado,XT,YT], GetDir, %obtem posição imediatamente a seguir na direção da que foi colocada
    move_piece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).        %move a peça para a posição obtida no predicado em cima
apply_move_dir(Board, GetDirPosFunc, GetOposDirFunc,Color,_,_,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):-
    Color = ColorEncontrada,    %quando as peças são de cor igual
    GetDir =.. [GetDirPosFunc,XEncontrado,YEncontrado,XT,YT], GetDir, %obtem posição imediatamente imediatamente a seguir da peça encontrada na direção pretendida 
    check_dir(Board,GetDirPosFunc,XT,YT,ColumnO,LineO,_), !, %procura outra peça na mesma direção para colidir, se não houver passa à seguinte instanciação
    GetOposDir =.. [GetOposDirFunc,ColumnO,LineO,TargetX,TargetY], GetOposDir,  %obtem posição anterior à encontrada, que é para lá onde se vai mover a peça inicialmente encontrada
    move_piece(Board,ColorEncontrada,XEncontrado,YEncontrado,TargetX,TargetY,NewBoard). %mover a peça
apply_move_dir(Board, GetDirPosFunc, _GetOposDirFunc,_,XColocado,YColocado,XEncontrado,YEncontrado,ColorEncontrada,NewBoard):- 
    get_void_dir(GetDirPosFunc,XColocado,YColocado,XT,YT),   %obtem a célula void encontrada na direção pretendida
    move_piece(Board,ColorEncontrada,XEncontrado,YEncontrado,XT,YT,NewBoard).    %move a peça para a zona void encontrada
get_void_dir(GetDirPosFunc,XI,YI,XV,YV):-    %obtem a célula void encontrada na direção pretendida
    verify_not_in_void(XI,YI), !, %ainda não chegou ao void
    GetDir =.. [GetDirPosFunc,XI,YI,X1,Y1], GetDir,
    get_void_dir(GetDirPosFunc,X1,Y1,XV,YV).
get_void_dir(_GetDirPosFunc,XI,YI,XV,YV):-    %chegou ao void
    XV = XI,
    YV = YI.


%Procura a primeira peça diretamente abaixo
check_dir(Board, _DirPosFunc, XI, YI, XO, YO, PieceO):-
    verify_in_board(XI,YI),
    ext_to_int(XI,YI,XX,YY),
    nth0(YY,Board,Linha),
    nth0(XX,Linha,Piece),
    Piece \= ' ',
    PieceO = Piece,
    XO is XI,
    YO is YI,
    !.
check_dir(Board, DirPosFunc, XI, YI, XO, YO, PieceO):-
    verify_in_board(XI,YI),
    DirPos =.. [DirPosFunc,XI,YI,X,Y], DirPos,!,
    %get_down_position(XI,YI,X,Y),
    check_dir(Board,DirPosFunc,X,Y,XO,YO,PieceO).

get_up_position(XI,YI,XO,YO):-
    XO is XI,
    YO is YI - 1.

get_down_position(XI,YI,XO,YO):-
    XO is XI,
    YO is YI + 1.

get_up_right_position(XI,YI,XO,YO):-
    XI < 4,
    XO is XI + 1,
    YO is YI.
get_up_right_position(XI,YI,XO,YO):-
    XI > 3,
    XO is XI + 1,
    YO is YI - 1.

get_up_left_position(XI,YI,XO,YO):-
    XI > 4,
    XO is XI - 1,
    YO is YI.
get_up_left_position(XI,YI,XO,YO):-
    XI < 5,
    XO is XI - 1,
    YO is YI - 1.

get_down_right_position(XI,YI,XO,YO):-
    XI < 4,
    XO is XI + 1,
    YO is YI +1.
get_down_right_position(XI,YI,XO,YO):-
    XI > 3,
    XO is XI + 1,
    YO is YI.

get_down_left_position(XI,YI,XO,YO):-
    XI > 4,
    XO is XI - 1,
    YO is YI + 1.
get_down_left_position(XI,YI,XO,YO):-
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

get_colour(Board,X,Y,Colour):-
    nth0(X,Board,Line),
    nth0(Y,Line,C),
    !,
    Colour = C.

get_colour(_,_,_,Colour):-
    Colour = ' '.

search_near(Board,X,Y,Colour):-
    assert(processed([X,Y])),
    assert(sequence(X,Y,Colour)),
    ext_to_int(C,L,Y,X),
    get_up_position(C,L,UPC,UPL),
    add_to_list(Board,UPC,UPL,Colour),
    get_down_position(C,L,DC,DL),
    add_to_list(Board,DC,DL,Colour),
    get_up_left_position(C,L,ULC,ULL),
    add_to_list(Board,ULC,ULL,Colour),
    get_up_right_position(C,L,URC,URL),
    add_to_list(Board,URC,URL,Colour),
    get_down_right_position(C,L,DRC,DRL),
    add_to_list(Board,DRC,DRL,Colour),
    get_down_left_position(C,L,DLC,DLL),
    add_to_list(Board,DLC,DLL,Colour).


add_to_list(Board,C,L,Colour):-
    verify_in_board(C,L),
    ext_to_int(C,L,Y,X),
    \+retract(processed([X,Y])),
    assert(processed([X,Y])),
    get_colour(Board,X,Y,NewColour),
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
    setof([III,VVV,CCC],sequence(III,VVV,CCC),ConnectedPieces),
    remove_pieces(Board,OutPieces,ConnectedPieces,NewBoardA,NewOPieces),
    search_board(NewBoardA,NewOPieces,NewBoard,NewOutPieces,X,Y2).

search_board(Board,OutPieces,NewBoard,NewOutPieces,_,_):-
    NewBoard = Board,
    NewOutPieces = OutPieces.

remove_pieces(Board,OutPieces,ConnectedPieces,NewBoard,NewOutPieces):-
    length(ConnectedPieces,Tam),
    Tam > 3,
    %print('Removing Whiskas saquetas!\n'),
    %read(_),
    remove_from_list(Board,OutPieces,NewBoard,ConnectedPieces,NewOutPieces).
remove_pieces(Board,OutPieces,_,NewBoard,NewOutPieces):-
    NewBoard = Board,
    NewOutPieces = OutPieces.

remove_from_list(Board,OutPieces,NewBoard,[[X,Y,Colour]|T],NewOutPieces):-
    nth0(X,Board,Linha),
    replace_nth0(Linha,Y,Colour,' ',NewLinha),
    replace_nth0(Board,X,Linha,NewLinha,NewBoardA),

    update_pieces(OutPieces,NewOPieces,X,Y,Colour),

    remove_from_list(NewBoardA,NewOPieces,NewBoard,T,NewOutPieces).
remove_from_list(Board,OutPieces,NewBoard,_,NewOutPieces):-
    NewBoard = Board,
    NewOutPieces = OutPieces.

update_pieces(outPieces(RedPointPiece,BluePointPiece,VoidPieces1,VoidPieces2),NewOutPieces,X,Y,Colour):-
    Colour = 'r',
    %print([X,Y]),
    ext_to_int(C,L,Y,X),
    verify_not_in_void(C,L),
    Out is RedPointPiece +1,
	NewOutPieces =.. [outPieces,Out,BluePointPiece,VoidPieces1,VoidPieces2].

update_pieces(outPieces(RedPointPiece,BluePointPiece,VoidPieces1,VoidPieces2),NewOutPieces,_,_,Colour):-
    Colour = 'r',
    Out is VoidPieces1 +1,   
	NewOutPieces =.. [outPieces,RedPointPiece,BluePointPiece,Out,VoidPieces2].

update_pieces(outPieces(RedPointPiece,BluePointPiece,VoidPieces1,VoidPieces2),NewOutPieces,X,Y,Colour):-
    Colour = 'b',
    ext_to_int(C,L,Y,X),
    verify_not_in_void(C,L),
    Out is BluePointPiece +1,    
	NewOutPieces =.. [outPieces,RedPointPiece,Out,VoidPieces1,VoidPieces2].

update_pieces(outPieces(RedPointPiece,BluePointPiece,VoidPieces1,VoidPieces2),NewOutPieces,_,_,Colour):-
    Colour = 'b',
    Out is VoidPieces2 +1,    
	NewOutPieces =.. [outPieces,RedPointPiece,BluePointPiece,VoidPieces1,Out].