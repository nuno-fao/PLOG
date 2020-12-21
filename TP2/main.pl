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
		
tan_and_white(Blank,Dir):-
	append(Blank,BlankS),
	append(Dir,DirS),
	domain(BlankS,0,1),
	tan_and_white(BlankS,DirS,0).
tan_and_white(Blank,Dir,P):-	
	nth0(P,Dir,Direction),
	nth0(P,Blank,Tan),
	setC(Blank,Dir,Direction,P,0,S,Tan),
	S #= 1+Tan.
	
	
%up up
setC(_,_,0,P,S,S,_):-	P<0.
setC(Blank,Dir,0,P,S,S0,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	P1 is P - 4,
	setC(Blank,Dir,0,P1,S,SO,Tan).
setC(Blank,Dir,0,P,S,SO,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece = Tan,
	S1 is S+1,
	P1 is P - 4,
	setC(Blank,Dir,0,P1,S1,SO,Tan).
	
%up right
setC(Blank,Dir,1,P,S,SO,Tan):-
	X is P mod 4,
	Y is div(P,4),
	setC(Blank,Dir,1,X,Y,S,SO,Tan).
setC(_,_,1,5,_,S,S,_).
setC(_,_,1,_,-1,S,S,_).
setC(Blank,Dir,1,X,Y,S,S0,Tan):-
	write(-X-Y),
	write('\n'),
	X>=0,
	Y>=0,
	P1 is Y * 4,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece \= Tan,
	X1 is X + 1,
	Y1 is Y - 1,
	setC(Blank,Dir,1,X1,Y1,S,SO,Tan).
setC(Blank,Dir,1,X,Y,S,S0,Tan):-
	write(X-Y),
	write('\n'),
	X>=0,
	Y>=0,
	P1 is Y * 4,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece = Tan,
	S1 is S +1,
	X1 is X + 1,
	Y1 is Y - 1,
	setC(Blank,Dir,1,X1,Y1,S1,SO,Tan).
	
	
setC(_,_,4,P,S,S,_):-	P>15.
setC(Blank,Dir,4,P,S,S0,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	P1 is P + 4,
	setC(Blank,Dir,4,P1,S,SO,Tan).
setC(Blank,Dir,4,P,S,SO,Tan):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece = Tan,
	S1 is S+1,
	P1 is P + 4,
	setC(Blank,Dir,4,P1,S1,SO,Tan).
	

	







