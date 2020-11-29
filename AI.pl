%chama o o ai especifico para o nivel de dificuldade, tendo em conta o jogador a maximizar e devolve em Move o movimento escolhido pelo AI
%choose_move(+GameState,+Player,+Level,-Move)
%chama o predicado ai que implementa uma ai, esse predicado guarda na base de dados o move associado a cada gamestate, o choose move 'hard' recupera esse move usando o gamestate devolvido pelo ai
choose_move(GameState, Player ,'hard', Move):-
    ai(GameState,Player,OutState),
    retract(moves(OutState,Move)),
    retractall(moves(_,_)).
%devolve um move aleatório entre o smoves permitidos
choose_move(GameState, Player ,'easy', Move):-
    valid_moves(GameState,Player,ListOfMoves),
    random_member(Move,ListOfMoves),
    print(Move).

%dado um GameState e o player a maximizar a pontuação, obtem os GameStates correspondentes aos moves possíveis e chama o get_max_of_sons que devolve o gamestate com maior valor
%ai(+GameState,+Player,-OutGameState)
ai(GameState,Player,OutGameState):-
    get_states(GameState,Player,NewGameStates),
    get_max_of_sons(NewGameStates,Player,-99999,GameState,OutGameState,_).

% percorre 'iterativamente' a lista NewGameStates, e compara os valores do gamestate atual com o valor do gamestate recebido em InGameState,
%caso seja superior passa para o próximo get_max_of_sons o gamestate e o value na cabeça da lista, caso contrário passa os gamestate e value recebidos
%get_max_of_sons(+NewGameStates,+Player,+InValue,+InGameState,-OutGameState,-OutValue).
get_max_of_sons([GameState|Rest],Player,InValue,InGameState,OutGameState,OutValue):-
get_max_of_sons([GameState|Rest],Player,InValue,InGameState,OutGameState,OutValue):-
    value(GameState,Player,NValue),
    get_max(NValue,GameState,InValue,InGameState,OValue,OGameState),
    get_max_of_sons(Rest,Player,OValue,OGameState,OutGameState,OutValue).
get_max_of_sons([GameState],Player,InValue,InGameState,OutGameState,OutValue):-
    value(GameState,Player,NValue),
    get_max(NValue,GameState,InValue,InGameState,OutValue,OutGameState).
    

%dados dois states e seu respetivos values devolve o maior state e o seu value
%caso sejam iguais devolve os valores dos dois primeiros parametros
%get_max(+Value1,+State1,+Value2,+State2,-OutValue,-OutState)
get_max(Value1,State1,Value2,State2,OutValue,OutState):-
    Value1 > Value2,
    OutValue = Value1,
    OutState = State1,
    !.
get_max(Value1,State1,Value2,State2,OutValue,OutState):-
    Value1 < Value2,
    OutValue = Value2,
    OutState = State2,
    !.
get_max(Value1,State1,Value1,_,Value1,State1).

%dado o GameState inicial chama valid_moves e passa para get_valid_moves_states que devolve os GameStates criados através da aplicação do move ao gamestate atual
%get_states(+GameState,+Player,-NewGameStates)
get_states(GameState,Player,NewGameStates):-
    valid_moves(GameState,Player,ListOfMoves),
    ListOfMoves \= [],
    get_valid_moves_states(ListOfMoves,GameState,NewGameStates).

% os moves recebidos sao aplicados ao gamestate e os GameStates resultantes sao devolvidos em NewGameStates
% o predicado guarda também, associado a cada gamestate o move que o criou para que seja posteriormente possivel recuperar esse move, 
% facto do tipo move(?GameState,?Move)
%get_valid_moves_states(+Moves,+GameState,-NewGameStates):-
get_valid_moves_states([[Colour,X,Y]|Moves],GameState,NewGameStates):-
    ext_to_int(CP,LP,Y,X),
    move(GameState,target(Colour,X, Y, CP, LP),NewGameState),
    assert(moves(NewGameState,[Colour,X,Y])),
    get_valid_moves_states(Moves,GameState,GameStates),
    NewGameStates = [NewGameState|GameStates].
get_valid_moves_states([],_,[]).