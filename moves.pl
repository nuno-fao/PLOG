valid_moves(gameState(Board,_,_,_),_,ListOfMoves):-
    check_line(Board,0,ListOfMoves).


%posição vazia -> válida -> adicionar à lista
check_pos(Line,P,[H|T],List) :-
    H = ' ',
    P1 is P + 1,
    check_pos(Line,P1,T,List1),
    Pos =.. [pos,Line,P],
    append([Pos],List1,List).
    
%não vazio -> segue em frente
check_pos(Line,P,[H|T],List) :-
    H \= ' ',
    P1 is P + 1,
    check_pos(Line,P1,T,List).

%lista vazia -> fim da coluna
check_pos(_,_,_,List):-
    List = [].

%obter linhas e colunas disponiveis (valor interno)
check_line([H|T],Row,List) :-
    check_pos(Row,0,H,List1),
    R1 is Row + 1,
    check_line(T,R1,List2),
    append(List1,List2,List).

%acabou
check_line(_,_,List) :-
    List = [].


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
    Out is 2.

get_col(_,Col,Out) :-
    Col = 7,
    Out is 3.

get_line(Line,Col,Out) :-
    Col < 5,
    Aux1 is Line - 1,
    Aux2 is 2*Aux1,
    Dif is 4 - Col,
    Out is Aux2 + Dif.

get_line(Line,Col,Out) :- 
    Aux1 is Line - 1,
    Aux2 is 2*Aux1,
    Dif is mod(Col,4),
    Out is Aux2 + Dif.

change_to_internal(Col,Line) :-
    get_col(Line,Col,Out1),
    get_line(Line,Col,Out2),
    format("Linha ~p Coluna ~p ~n",[Out2,Out1]).

change_to_internal(Col,Line,NewCol,NewLine) :-
    get_col(Line,Col,NewCol),
    get_line(Line,Col,NewLine),
    format("Linha ~p Coluna ~p ~n",[NewLine,NewCol]).


