# To run the application just choose one of the following ways:
## Predefined Puzzle (1-8):
> problem(X,A),solver(A).
## Random Puzzle, X is the size of the square Matrix (4, 5 or 6 only):
> create(X,A),solver(A).
## Manual Puzzle:
> solver([[4,4,5,6],[3,3,5,6],[2,1,6,7],[0,2,7,0]]).
## No printing, just solving and confirmation (input the matrix any way you desire):
> tan_and_white([[4,4,5,6],[3,3,5,6],[2,1,6,7],[0,2,7,0]],Sol).
