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

tan_and_white(Blank,Dir):-
	append(Blank,BlankS),
	append(Dir,DirS),
	length(DirS,SD),
	length(BlankS,SB),
	SD = SB,
	length(Blank,L),
	nth0(0,Blank,Linha),
	length(Linha,C),
	domain(BlankS,0,1),
	tan_and_white(BlankS,DirS,0,SD,C,L).
tan_and_white(Blank,Dir,P,Size,Col,Line):-	
	S #= 2+Tan,
	nth0(P,Dir,Direction),
	nth0(P,Blank,Tan),
	setC(Blank,Dir,Direction,P,0,S,Tan,Size,Col,Line),
	P1 is P +1,
	!,
	tan_and_white(Blank,Dir,P1,Size,Col,Line).
tan_and_white(Blank,Dir,P,Size,Col,Line):- 
	P>=Size.

	
%up up
setC(_,_,0,P,S,S1,_,_,_,_):-	P<0,S1 is S.
setC(Blank,Dir,0,P,S,SO,Tan,Size,Col,Line):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	P1 is P - Col,
	setC(Blank,Dir,0,P1,S,SO,Tan,Size,Col,Line).
setC(Blank,Dir,0,P,S,SO,Tan,Size,Col,Line):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece = Tan,
	S1 is S+1,
	P1 is P - Col,
	setC(Blank,Dir,0,P1,S1,SO,Tan,Size,Col,Line).
	
%up right
setC(Blank,Dir,1,P,S,SO,Tan,Size,Col,Line):-
	X is P mod Col,
	Y is div(P,Col),
	setC(Blank,Dir,1,X,Y,S,SO,Tan,Size,Col,Line).
setC(_,_,1,X,_,S,S,_,Size,X,Line).
setC(_,_,1,_,-1,S,S,_,Size,Col,Line).
setC(Blank,Dir,1,X,Y,S,SO,Tan,Size,Col,Line):-
	X <Col,
	X>=0,
	Y>=0,
	P1 is Y * Col,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece \= Tan,
	X1 is X + 1,
	Y1 is Y - 1,
	setC(Blank,Dir,1,X1,Y1,S,SO,Tan,Size,Col,Line).
setC(Blank,Dir,1,X,Y,S,SO,Tan,Size,Col,Line):-
	X<Col,
	X>=0,
	Y>=0,
	P1 is Y * Col,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece = Tan,
	S1 is S +1,
	X1 is X + 1,
	Y1 is Y - 1,
	setC(Blank,Dir,1,X1,Y1,S1,SO,Tan,Size,Col,Line).
	
%right
setC(Blank,Dir,2,P,S,SO,Tan,Size,Col,Line):-
	P>=0,
	P1 is P + 1,
	Out is div(P,Col),
	Out1 is div(P1,Col),
	Out = Out1,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	setC(Blank,Dir,2,P1,S,SO,Tan,Size,Col,Line).
setC(Blank,Dir,2,P,S,SO,Tan,Size,Col,Line):-
	P>=0,
	P1 is P + 1,
	Out is div(P,Col),
	Out1 is div(P1,Col),
	Out = Out1,
	nth0(P,Blank,Piece),
	Piece = Tan,
	S1 is S+1,
	setC(Blank,Dir,2,P1,S1,SO,Tan,Size,Col,Line).
setC(Blank,Dir,2,P,S,SO,Tan,Size,Col,Line):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece = Tan,
	SO is S + 1.
setC(_,_,2,P,S,S,_,Size,Col,Line):- write(S),write('\n').

%down right
setC(Blank,Dir,3,P,S,SO,Tan,Size,Col,Line):-
	X is P mod Col,
	Y is div(P,Col),
	setC(Blank,Dir,3,X,Y,S,SO,Tan,Size,Col,Line).
setC(_,_,3,X,_,S,S,_,Size,X,Line).
setC(_,_,3,_,Y,S,S,_,Size,Col,Y).
setC(Blank,Dir,3,X,Y,S,SO,Tan,Size,Col,Line):-
	X <Col,
	Y<Line,
	X>=0,
	Y>=0,
	P1 is Y * Col,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece \= Tan,
	X1 is X + 1,
	Y1 is Y + 1,
	setC(Blank,Dir,3,X1,Y1,S,SO,Tan,Size,Col,Line).
setC(Blank,Dir,3,X,Y,S,SO,Tan,Size,Col,Line):-
	X<Col,
	Y<Line,
	X>=0,
	Y>=0,
	P1 is Y * Col,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece = Tan,
	S1 is S +1,
	X1 is X + 1,
	Y1 is Y + 1,
	setC(Blank,Dir,3,X1,Y1,S1,SO,Tan,Size,Col,Line).
	
	
%down down
setC(_,_,4,P,S,S1,_,Size,_,_):-	P>=Size,S1 is S.
setC(Blank,Dir,4,P,S,SO,Tan,Size,Col,Line):-
	write(1),
	P<Size,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	P1 is P + Col,
	setC(Blank,Dir,4,P1,S,SA,Tan,Size,Col,Line),
	SO is SA.
setC(Blank,Dir,4,P,S,SO,Tan,Size,Col,Line):-
	write(2),
	P<Size,
	nth0(P,Blank,Piece),
	Piece == Tan,
	S1 is S+1,
	P1 is P + Col,
	setC(Blank,Dir,4,P1,S1,SA,Tan,Size,Col,Line),
	SO is SA.
	
%down left
setC(Blank,Dir,5,P,S,SO,Tan,Size,Col,Line):-
	X is P mod Col,
	Y is div(P,Col),
	setC(Blank,Dir,5,X,Y,S,SO,Tan,Size,Col,Line).
setC(_,_,5,-1,_,S,S,_,Size,Col,Line).
setC(_,_,5,_,Y,S,S,_,Size,Col,Y).
setC(Blank,Dir,5,X,Y,S,SO,Tan,Size,Col,Line):-
	Y<Line,
	X>=0,
	Y>=0,
	P1 is Y * Col,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece \= Tan,
	X1 is X - 1,
	Y1 is Y + 1,
	setC(Blank,Dir,5,X1,Y1,S,SO,Tan,Size,Col,Line).
setC(Blank,Dir,5,X,Y,S,SO,Tan,Size,Col,Line):-
	Y<Line,
	X>=0,
	Y>=0,
	P1 is Y * Col,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece = Tan,
	S1 is S +1,
	X1 is X - 1,
	Y1 is Y + 1,
	setC(Blank,Dir,5,X1,Y1,S1,SO,Tan,Size,Col,Line).

%lef
setC(Blank,Dir,6,P,S,SO,Tan,Size,Col,Line):-
	P>=0,
	P1 is P - 1,
	Out is div(P,Col),
	Out1 is div(P1,Col),
	Out = Out1,
	nth0(P,Blank,Piece),
	Piece \= Tan,
	setC(Blank,Dir,6,P1,S,SO,Tan,Size,Col,Line).
setC(Blank,Dir,6,P,S,SO,Tan,Size,Col,Line):-
	P>=0,
	P1 is P - 1,
	Out is div(P,Col),
	Out1 is div(P1,Col),
	Out = Out1,
	nth0(P,Blank,Piece),
	Piece = Tan,
	S1 is S+1,
	setC(Blank,Dir,6,P1,S1,SO,Tan,Size,Col,Line).
setC(Blank,Dir,6,P,S,SO,Tan,Size,Col,Line):-
	P>=0,
	nth0(P,Blank,Piece),
	Piece = Tan,
	SO is S + 1.
setC(_,_,6,P,S,S,_,Size,Col,Line):- write(S),write('\n').

%up left
setC(Blank,Dir,7,P,S,SO,Tan,Size,Col,Line):-
	X is P mod Col,
	Y is div(P,Col),
	setC(Blank,Dir,7,X,Y,S,SO,Tan,Size,Col,Line).
setC(_,_,7,-1,_,S,S,_,Size,Col,Line).
setC(_,_,7,_,-1,S,S,_,Size,Col,Line).
setC(Blank,Dir,7,X,Y,S,SO,Tan,Size,Col,Line):-
	X>=0,
	Y>=0,
	P1 is Y * Col,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece \= Tan,
	X1 is X - 1,
	Y1 is Y - 1,
	setC(Blank,Dir,7,X1,Y1,S,SO,Tan,Size,Col,Line).
setC(Blank,Dir,7,X,Y,S,SO,Tan,Size,Col,Line):-
	X>=0,
	Y>=0,
	P1 is Y * Col,
	P2 is P1 + X,
	nth0(P2,Blank,Piece),
	Piece = Tan,
	S1 is S +1,
	X1 is X - 1,
	Y1 is Y - 1,
	setC(Blank,Dir,7,X1,Y1,S1,SO,Tan,Size,Col,Line).
	

%spy(setC),problem(2,A,B),tan_and_white(A,B).
%problem(1,A,B),tan_and_white(A,B).
%problem(3,A,B),tan_and_white(A,B).
%problem(4,A,B),tan_and_white(A,B).






