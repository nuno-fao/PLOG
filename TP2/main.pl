:- use_module(library(clpfd)).
:- use_module(library(lists)).     
            
problem(1,

    [	[_,_,_,_],
	[_,_,_,_],
	[_,_,_,_],
	[_,_,_,_]],
	
    [	[1,4,5,6],
	[3,2,5,6],
	[2,1,6,7],
	[0,2,7,0]]		
		).
		
		
problem(2,

    [	[_,_],
	[_,_]],
	
    [	[3,5],
	[1,7]]		
		).
		
tan_and_white(Blank,Dir):-
	append(Blank,BlankS),
	append(Dir,DirS),
	domain(BlankS,0,1),
	tan_and_white(BlankS,DirS,0).
tan_and_white(Blank,Dir,P):-	
	S #= 2+Tan,
	nth0(P,Dir,Direction),
	nth0(P,Blank,Tan),
	setC(Blank,Dir,Direction,P,0,S,Tan),
	P1 is P +1,
	!,
	tan_and_white(Blank,Dir,P1).
tan_and_white(Blank,Dir,P):- P>3.
	
%up up
setC(_,_,0,P,S,S1,_):-	P<0,S1 is S.
setC(Blank,Dir,0,P,S,SO,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	P1 is P - 2,
	setC(Blank,Dir,0,P1,S,SO,Tan).
setC(Blank,Dir,0,P,S,SO,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece = Tan,
	S1 is S+1,
	P1 is P - 2,
	setC(Blank,Dir,0,P1,S1,SO,Tan).
	
%up right
setC(Blank,Dir,1,P,S,SO,Tan):-
	X is P mod 2,
	Y is div(P,2),
	setC(Blank,Dir,1,X,Y,S,SO,Tan).
setC(_,_,1,2,_,S,S,_).
setC(_,_,1,_,-1,S,S,_).
setC(Blank,Dir,1,X,Y,S,SO,Tan):-
	X <2,
	X>=0,
	Y>=0,
	P1 is Y * 2,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece \= Tan,
	X1 is X + 1,
	Y1 is Y - 1,
	setC(Blank,Dir,1,X1,Y1,S,SO,Tan).
setC(Blank,Dir,1,X,Y,S,SO,Tan):-
	X<2,
	X>=0,
	Y>=0,
	P1 is Y * 2,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece = Tan,
	S1 is S +1,
	X1 is X + 1,
	Y1 is Y - 1,
	setC(Blank,Dir,1,X1,Y1,S1,SO,Tan).
	
%right
setC(Blank,Dir,2,P,S,SO,Tan):-
	P>=0,
	P1 is P + 1,
	Out is div(P,2),
	Out1 is div(P1,2),
	write(Out-Out1),
	write('\n'),
	Out = Out1,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	setC(Blank,Dir,2,P1,S,SO,Tan).
setC(Blank,Dir,2,P,S,SO,Tan):-
	P>=0,
	P1 is P + 1,
	Out is div(P,2),
	Out1 is div(P1,2),
	write(Out-Out1),
	write('\n'),
	Out = Out1,
	nth0(P,Blank,Piece),
	Piece = Tan,
	S1 is S+1,
	setC(Blank,Dir,2,P1,S1,SO,Tan).
setC(Blank,Dir,2,P,S,SO,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece = Tan,
	SO is S + 1.
setC(_,_,2,P,S,S,_):- write(S),write('\n').

%down right
setC(Blank,Dir,3,P,S,SO,Tan):-
	X is P mod 2,
	Y is div(P,2),
	setC(Blank,Dir,3,X,Y,S,SO,Tan).
setC(_,_,3,2,_,S,S,_).
setC(_,_,3,_,2,S,S,_).
setC(Blank,Dir,3,X,Y,S,SO,Tan):-
	X <2,
	Y<2,
	X>=0,
	Y>=0,
	P1 is Y * 2,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece \= Tan,
	X1 is X + 1,
	Y1 is Y + 1,
	setC(Blank,Dir,3,X1,Y1,S,SO,Tan).
setC(Blank,Dir,3,X,Y,S,SO,Tan):-
	X<2,
	Y<2,
	X>=0,
	Y>=0,
	P1 is Y * 2,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece = Tan,
	S1 is S +1,
	X1 is X + 1,
	Y1 is Y + 1,
	setC(Blank,Dir,3,X1,Y1,S1,SO,Tan).
	
	
	
setC(_,_,4,P,S,S,_):-	P>3.
setC(Blank,Dir,4,P,S,SO,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	P1 is P + 2,
	setC(Blank,Dir,4,P1,S,SO,Tan).
setC(Blank,Dir,4,P,S,SO,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece = Tan,
	S1 is S+1,
	P1 is P + 2,
	setC(Blank,Dir,4,P1,S1,SO,Tan).
	
	
%down left
setC(Blank,Dir,5,P,S,SO,Tan):-
	X is P mod 2,
	Y is div(P,2),
	setC(Blank,Dir,5,X,Y,S,SO,Tan).
setC(_,_,5,-1,_,S,S,_).
setC(_,_,5,_,2,S,S,_).
setC(Blank,Dir,5,X,Y,S,SO,Tan):-
	Y<2,
	X>=0,
	Y>=0,
	P1 is Y * 2,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece \= Tan,
	X1 is X - 1,
	Y1 is Y + 1,
	setC(Blank,Dir,5,X1,Y1,S,SO,Tan).
setC(Blank,Dir,5,X,Y,S,SO,Tan):-
	Y<2,
	X>=0,
	Y>=0,
	P1 is Y * 2,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece = Tan,
	S1 is S +1,
	X1 is X - 1,
	Y1 is Y + 1,
	setC(Blank,Dir,5,X1,Y1,S1,SO,Tan).

%lef
setC(Blank,Dir,6,P,S,SO,Tan):-
	P>=0,
	P1 is P - 1,
	Out is div(P,2),
	Out1 is div(P1,2),
	write(Out-Out1),
	write('\n'),
	Out = Out1,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	setC(Blank,Dir,6,P1,S,SO,Tan).
setC(Blank,Dir,6,P,S,SO,Tan):-
	P>=0,
	P1 is P - 1,
	Out is div(P,2),
	Out1 is div(P1,2),
	write(Out-Out1),
	write('\n'),
	Out = Out1,
	nth0(P,Blank,Piece),
	Piece = Tan,
	S1 is S+1,
	setC(Blank,Dir,6,P1,S1,SO,Tan).
setC(Blank,Dir,6,P,S,SO,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece = Tan,
	SO is S + 1.
setC(_,_,6,P,S,S,_):- write(S),write('\n').

%up left
setC(Blank,Dir,7,P,S,SO,Tan):-
	X is P mod 2,
	Y is div(P,2),
	setC(Blank,Dir,7,X,Y,S,SO,Tan).
setC(_,_,7,-1,_,S,S,_).
setC(_,_,7,_,-1,S,S,_).
setC(Blank,Dir,7,X,Y,S,SO,Tan):-
	X>=0,
	Y>=0,
	P1 is Y * 2,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece \= Tan,
	X1 is X - 1,
	Y1 is Y - 1,
	setC(Blank,Dir,7,X1,Y1,S,SO,Tan).
setC(Blank,Dir,7,X,Y,S,SO,Tan):-
	X>=0,
	Y>=0,
	P1 is Y * 2,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece = Tan,
	S1 is S +1,
	X1 is X - 1,
	Y1 is Y - 1,
	setC(Blank,Dir,7,X1,Y1,S1,SO,Tan).
	

%spy(setC),problem(2,A,B),tan_and_white(A,B).





