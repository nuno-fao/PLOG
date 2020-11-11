valid_moves(gameState(Board,_,_,_),_,ListOfMoves):-
    check_line(Board,1,ListOfMoves).


get_start_column(Line,Start):-
    (Line=1; Line=13),
    X1 is 4,
    Start is X1,
    !.
get_start_column(Line,Start):-
    (Line=2; Line=12),
    !,
    Start is 3.
get_start_column(Line,Start):-
    (Line=3; Line=11),
    !,
    Start is 2.
get_start_column(Line,Start):-
    even(Line),
    Start is 1.
get_start_column(Line,Start):-
    odd(Line),
    Start is 2.

%posição vazia -> válida -> adicionar à lista
check_pos(Line,P,[H|T],List) :-
    H = ' ',
    P1 is P + 2,
    %Aux is Line + 1,
    check_pos(Line,P1,T,List1),
    Pos =.. [pos,P,Line],
    append([Pos],List1,List).
    

%não vazio
%check_pos(Line,P,[H|T],List) :-

%lista vazia -> fim da coluna
check_pos(_,_,_,List):-
    List = [].

check_line([H|T],Row,List) :-
    get_start_column(Row,Col),
    check_pos(Row,Col,H,List1),
    R1 is Row + 1,
    check_line(T,R1,List2),
    append(List1,List2,List).
check_line(_,_,List):-
    List = [].

    
    