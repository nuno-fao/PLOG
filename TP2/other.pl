:- use_module(library(clpfd)).
:- use_module(library(lists)).     
:- use_module(library(random)).
:- use_module(library(matrix)).
            
problem(1,
   [[4,4,5,6],
	[3,3,5,6],
	[2,1,6,7],
	[0,2,7,0]]		
		).
		
		
problem(2,
    [	[4,5],
	[1,7]]		
		).
problem(3,
	[[4,4,5,6,6],
	 [2,2,3,4,6],
	 [1,0,7,6,0],
	 [1,1,0,0,6],
	 [0,1,0,7,0]
	]
).


problem(4,[[4,6,5],[3,7,7],[2,6,7]]).

problem(5,
	[[3,2,3,3,2,4],
	[2,5,3,1,4,0],
	[1,1,0,2,5,5],
	[0,0,1,0,0,4],
	[1,0,2,0,5,0],
	[0,1,1,1,0,7]
	]
).

length_(Length, List) :- length(List, Length).

list2matrix(List, RowSize, Matrix) :-
    length(List, L),
    HowManyRows is L div RowSize,
    length(Matrix, HowManyRows),
    maplist(length_(RowSize), Matrix),
    append(Matrix, List).


matrix_generator(Size,1,Matrix):-	
	length(M2,Size),
	M3 = M2,
	Matrix = [M3].	
matrix_generator(Size,Left,Matrix):-
	Left > 1,
	L is Left - 1,
	matrix_generator(Size,L,M1),
	length(M2,Size),
	append([M2],M1,M3),
	Matrix = M3.	

solver(Dir,Solution):-
	tan_and_white(Dir,Solution),
	print_matrix(Dir),nl,
	print_matrix(Solution),nl.

tan_and_white(Dir,Solution):-
	length(Dir,SizeD),
	matrix_generator(SizeD,SizeD,Blank),
	domain_to_list(Blank,0,1),
	length(Blank,L),
	nth0(0,Blank,Linha),
	length(Linha,C),
	statistics(total_runtime, _),
	tan_and_white(Blank,Dir,0,0,Size,C,L,Solution).

print_time(Msg):-statistics(total_runtime,[_,T]),TS is ((T//10)*10)/1000, nl,write(Msg), write(TS), write('s'), nl, nl.


tan_and_white(Blank,Dir,X,Y,Size,Col,Line,Blank):- 
	X>=Col.
	%print_time("Time: "),
	%fd_statistics,statistics,
	%write(Blank).
tan_and_white(Blank,Dir,X,Y,Size,Col,Line,Blank):- 
	Y>=Line.
	%print_time("Time: "),
	%fd_statistics,statistics,
	%write(Blank).
tan_and_white(Blank,Dir,X,Y,Size,Col,Line,O):-
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

	tan_and_white(Blank,Dir,X1,Y1,Size,Col,Line,O).

get_list(Tan,Dir,Blank,X,Y,Cols,Lines,Lista):-
	Tan #= 1,
	get_list(Dir,Blank,X,Y,Cols,Lines,Lista),
	length(Lista,LL),
	S #= LL - 3,
	global_cardinality(Lista,[0-S,1-3]).

get_list(Tan,Dir,Blank,X,Y,Cols,Lines,Lista):-
	Tan #= 0,
	get_list(Dir,Blank,X,Y,Cols,Lines,Lista),
	length(Lista,LL),
	S #= LL - 2,
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


domain_to_list([],_,_).
domain_to_list([List|H],Bot,Up):-
	domain(List,Bot,Up),
	domain_to_list(H,Bot,Up).
	
domain_to_first_line([List|H]):-
	domain(List,2,6).	
	
create(Size,Matrix):-
	List_length #= Size,
	length(M,List_length),
	matrix_generator(Size,Size,M),
	create_random(Size,Matrix,M,B).
	
create_random(Size,Matrix,M,B):-
	domain_to_list(M,0,7),	
	domain_to_first_line(M),
	append(M,MM),
	nth0(1,M,M1),
	nth0(1,M1,P1),
	nth0(0,M,M2),
	nth0(0,M2,P2),
	random(0,7,R11),
	random(2,4,R00),
	P1 #= R11,
	P2 #= R00,
	
	tan_and_white(M,_),
	list2matrix(MM,Size,M),
	Matrix = M,
	(B = N,print_matrix(M)) ; (B\=N,fail).


print_matrix([]).
print_matrix([H|R]):- 
	write(H), 
	nl, 
	print_matrix(R).


%problem(2,B),solver(B,O).
%problem(1,B),solver(B,O).
%problem(3,B),solver(B,O).
%problem(4,B),solver(B,O).
%problem(5,B),solver(B,O).


