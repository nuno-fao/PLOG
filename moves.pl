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
check_line(_,_,List):-
    List = [].

    
