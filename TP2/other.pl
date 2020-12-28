:- use_module(library(clpfd)).
:- use_module(library(lists)).     
            
problem(1,

    [	[_,_,_,_],
	[_,_,_,_],
	[_,_,_,_],
	[_,_,_,_]],
	
   [[4,4,5,6],
	[3,3,5,6],
	[2,1,6,7],
	[0,2,7,0]]		
		).
		
		
problem(2,

    [	[_,_],
	[_,_]],
	
    [	[4,5],
	[1,7]]		
		).
		
problem(3,

    [	[_,_,_,_],
	[_,_,_,_]],
	
    [	[4,4,4,4],
	[0,0,0,0]]		
		).


problem(4,

    [	[_,_],
	[_,_],
	[_,_]],
	
    [	[3,5],
	[1,7],
	[2,6]]		
		).

problem(5,
	[[_,_,_,_,_],
	 [_,_,_,_,_],
	 [_,_,_,_,_],
	 [_,_,_,_,_],
	 [_,_,_,_,_]
 	],
	[[4,4,5,6,6],
	 [2,2,3,4,6],
	 [1,0,7,6,0],
	 [1,1,0,0,6],
	 [0,1,0,7,0]
	]

).

length_(Length, List) :- length(List, Length).

list2matrix(List, RowSize, Matrix) :-
    length(List, L),
    HowManyRows is L div RowSize,
    length(Matrix, HowManyRows),
    maplist(length_(RowSize), Matrix),
    append(Matrix, List).

tan_and_white(Blank,Dir):-
	append(Blank,BlankS),
	append(Dir,DirS),
	length(DirS,Size),
	length(BlankS,SB),
	Size = SB,
	length(Blank,L),
	nth0(0,Blank,Linha),
	length(Linha,C),
	domain(BlankS,0,1),
	
	list2matrix(BlankS,C,Matrix),

	statistics(total_runtime, _),
	tan_and_white(Matrix,Dir,0,0,Size,C,L).

print_time(Msg):-statistics(total_runtime,[_,T]),TS is ((T//10)*10)/1000, nl,write(Msg), write(TS), write('s'), nl, nl.


tan_and_white(Blank,Dir,X,Y,Size,Col,Line):- 
	X>=Col,
	print_time(Time: ’),
	fd_statistics,statistics.
tan_and_white(Blank,Dir,X,Y,Size,Col,Line):- 
	Y>=Line,
	print_time(Time: ’),
	fd_statistics,statistics.
tan_and_white(Blank,Dir,X,Y,Size,Col,Line):-
	nth0(Y,Blank,BlankR),
	nth0(X,BlankR,B),

	nth0(Y,Dir,DirR),
	nth0(X,DirR,D),

	get_list(B,D,Blank,X,Y,Col,Line,Lista),

	P is Y * Col,
	P1 is P + X,
	P2 is P1 + 1,
	X1 is P2 mod Col,
	Y1 is div(P2,Col), 

	tan_and_white(Blank,Dir,X1,Y1,Size,Col,Line).

get_list(Tan,Dir,Blank,X,Y,Cols,Lines,Lista):-
	Tan #= 1,
	get_list(Dir,Blank,X,Y,Cols,Lines,Lista),
	length(Lista,LL),
	S #= LL - 3,
	write(Blank),
	nl,
	global_cardinality(Lista,[0-S,1-3]).

get_list(Tan,Dir,Blank,X,Y,Cols,Lines,Lista):-
	Tan #= 0,
	get_list(Dir,Blank,X,Y,Cols,Lines,Lista),
	length(Lista,LL),
	S #= LL - 2,
	write(Blank),
	nl,
	global_cardinality(Lista,[0-2,1-S]).


get_list(0,Blank,X,Y,Cols,Lines,Lista):-
	Y<0,
	Lista = [].
get_list(0,Blank,X,Y,Cols,Lines,Lista):-
	Y >= 0,
	Y1 is Y - 1,
	get_list(0,Blank,X,Y1,Cols,Lines,OutLista),
	nth0(Y,Blank,Row),
	nth0(X,Row,Elem),
	Lista = [Elem|OutLista]. 

get_list(1,Blank,X,Y,Cols,Lines,Lista):-
	Y<0,
	Lista = [].
get_list(1,Blank,X,Y,Cols,Lines,Lista):-
	X>=Cols,
	Lista = [].
get_list(1,Blank,X,Y,Cols,Lines,Lista):-
	Y >= 0,
	X < Cols,
	Y1 is Y - 1,
	X1 is X + 1,
	get_list(1,Blank,X1,Y1,Cols,Lines,OutLista),
	nth0(Y,Blank,Row),
	nth0(X,Row,Elem),
	Lista = [Elem|OutLista]. 

get_list(2,Blank,X,Y,Cols,Lines,Lista):-
	X>=Cols,
	Lista = [].
get_list(2,Blank,X,Y,Cols,Lines,Lista):-
	X < Cols,
	X1 is X + 1,
	get_list(2,Blank,X1,Y,Cols,Lines,OutLista),
	nth0(Y,Blank,Row),
	nth0(X,Row,Elem),
	Lista = [Elem|OutLista].

get_list(3,Blank,X,Y,Cols,Lines,Lista):-
	Y>=Lines,
	Lista = [].
get_list(3,Blank,X,Y,Cols,Lines,Lista):-
	X>=Cols,
	Lista = [].
get_list(3,Blank,X,Y,Cols,Lines,Lista):-
	Y < Lines,
	X < Cols,
	Y1 is Y + 1,
	X1 is X + 1,
	get_list(3,Blank,X1,Y1,Cols,Lines,OutLista),
	nth0(Y,Blank,Row),
	nth0(X,Row,Elem),
	Lista = [Elem|OutLista]. 

get_list(4,Blank,X,Y,Cols,Lines,Lista):-
	Y >= Lines,
	Lista = [].
get_list(4,Blank,X,Y,Cols,Lines,Lista):-
	Y < Lines,
	Y1 is Y + 1,
	get_list(4,Blank,X,Y1,Cols,Lines,OutLista),
	nth0(Y,Blank,Row),
	nth0(X,Row,Elem),
	Lista = [Elem|OutLista]. 

get_list(5,Blank,X,Y,Cols,Lines,Lista):-
	Y>=Lines,
	Lista = [].
get_list(5,Blank,X,Y,Cols,Lines,Lista):-
	X < 0,
	Lista = [].
get_list(5,Blank,X,Y,Cols,Lines,Lista):-
	Y < Lines,
	X >= 0,
	Y1 is Y + 1,
	X1 is X - 1,
	get_list(5,Blank,X1,Y1,Cols,Lines,OutLista),
	nth0(Y,Blank,Row),
	nth0(X,Row,Elem),
	Lista = [Elem|OutLista]. 

get_list(6,Blank,X,Y,Cols,Lines,Lista):-
	X < 0,
	Lista = [].
get_list(6,Blank,X,Y,Cols,Lines,Lista):-
	X >= 0,
	X1 is X - 1,
	get_list(6,Blank,X1,Y,Cols,Lines,OutLista),
	nth0(Y,Blank,Row),
	nth0(X,Row,Elem),
	Lista = [Elem|OutLista].

get_list(7,Blank,X,Y,Cols,Lines,Lista):-
	X < 0,
	Lista = [].
get_list(7,Blank,X,Y,Cols,Lines,Lista):-
	Y < 0,
	Lista = [].
get_list(7,Blank,X,Y,Cols,Lines,Lista):-
	Y >= 0,
	X >= 0,
	Y1 is Y - 1,
	X1 is X - 1,
	get_list(7,Blank,X1,Y1,Cols,Lines,OutLista),
	nth0(Y,Blank,Row),
	nth0(X,Row,Elem),
	Lista = [Elem|OutLista]. 

%spy(setC),problem(2,A,B),tan_and_white(A,B).
%problem(1,A,B),tan_and_white(A,B).
%problem(3,A,B),tan_and_white(A,B).
%problem(4,A,B),tan_and_white(A,B).
%problem(5,A,B),tan_and_white(A,B).






