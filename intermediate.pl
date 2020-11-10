
intermediate_board([
            [' '],  
          [' ',' '],
        [' ','R','B'],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ','R',' '],
        ['B',' ',' '],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        ['B',' ',' '],
          ['B',' '],
            [' '] 
]).
intermediate_unused_pieces([[7,2],[2,8]]).
intermediate_out_pieces([[4,0],[0,1]]).
intermesdiate_player(1).

%inicializar o GameState com uma lista de listas com informação do estado de jogo intermédio
intermediate_state(GameState) :-
	intermediate_board(Board),
	intermediate_unused_pieces(UnusedPieces),
	intermediate_out_pieces(OutPieces),
	intermesdiate_player(Player),
	GameState = [Board,UnusedPieces,OutPieces,Player].
	
final_board([
            [' '],  
          [' ',' '],
        [' ','R','B'],
      [' ','R',' ',' '],
        [' ',' ',' '],
      [' ',' ','R',' '],
        ['B',' ','B'],
      [' ',' ','B',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        ['B',' ',' '],
          ['B',' '],
            [' '] 
]).
final_unused_pieces([[0,0],[0,0]]).
final_out_pieces([[12,4],[0,3]]).
final_player(1).

%inicializar o GameState com uma lista de listas com informação do estado de jogo final
final_state(GameState) :-
	final_board(Board),
	final_unused_pieces(UnusedPieces),
	final_out_pieces(OutPieces),
	final_player(Player),
	GameState = [Board,UnusedPieces,OutPieces,Player].