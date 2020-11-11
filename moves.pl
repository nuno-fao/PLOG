valid_moves(gameState(Board,_,_,_),_,ListOfMoves):-
    check_line(Board,0,ListOfMoves).

check_pos(Line,_,[H|T],List) :-
    H = ' ',
    Line = 0,
    L1 is Line +1,
    Pos =.. [pos,4,L1],
    append([Pos],List1,List).
check_pos(Line,_,[H|T],List) :-
    H = ' ',
    Line = 12,
    L1 is Line +1,
    Pos =.. [pos,4,L1],
    append([Pos],List1,List).
check_pos(Line,P,[H|T],List) :-
    H = ' ',
    Line = 1,
    L1 is Line + 1,
    P1 is P*2 + 3,
    PO is P + 1,
    check_pos(Line,PO,T,List1),
    Pos =.. [pos,P1,Line],
    append([Pos],List1,List).
check_pos(Line,P,[H|T],List) :-
    H = ' ',
    Line = 11,
    L1 is Line + 1,
    P1 is P*2 + 3,
    PO is P + 1,
    check_pos(Line,PO,T,List1),
    Pos =.. [pos,P1,Line],
    append([Pos],List1,List).
check_pos(Line,P,[H|T],List) :-
    H = ' ',
    P1 is P + 1,
    check_pos(Line,P1,T,List1),
    Pos =.. [pos,P,Line],
    append([Pos],List1,List).
check_pos(_,_,_,List):-
    List = [].

check_line([H|T],Row,List) :-
    check_pos(Row,0,H,List1),
    R1 is Row + 1,
    check_line(T,R1,List2),
    append(List1,List2,List).
check_line(_,_,List):-
    List = [].

    
    