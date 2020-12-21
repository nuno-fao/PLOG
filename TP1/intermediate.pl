
intermediate_board([
            [' '],  
          [' ',' '],
        [' ','r','b'],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ','r',' '],
        ['b',' ',' '],
      [' ',' ',' ',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        ['b',' ',' '],
          ['b',' '],
            [' '] 
]).
intermediate_unused_pieces([7,2,2,8]).
intermediate_out_pieces([4,0,0,1]).
intermediate_player(1).

%inicializar o GameState com uma lista de listas com informação do estado de jogo intermédio
intermediate_state(GameState) :-
	intermediate_board(Board),
	intermediate_unused_pieces(UnusedPiecesL),
	intermediate_out_pieces(OutPiecesL),
	intermediate_player(Player),

  UnusedPieces =.. [unusedPieces|UnusedPiecesL],
  OutPieces =.. [outPieces|OutPiecesL],
	GameState =.. [gameState,Board,UnusedPieces,OutPieces,Player].
	
final_board([
            [' '],  
          [' ',' '],
        [' ','r','b'],
      [' ','r',' ',' '],
        [' ',' ',' '],
      [' ',' ','r',' '],
        ['b',' ','b'],
      [' ',' ','b',' '],
        [' ',' ',' '],
      [' ',' ',' ',' '],
        ['b',' ',' '],
          ['b',' '],
            [' '] 
]).
final_unused_pieces([0,0,0,0]).
final_out_pieces([9,6,3,3]).
final_player(1).

%inicializar o GameState com uma lista de listas com informação do estado de jogo final
final_state(GameState) :-
	final_board(Board),
	final_unused_pieces(UnusedPiecesL),
	final_out_pieces(OutPiecesL),
	final_player(Player),

	UnusedPieces =.. [unusedPieces|UnusedPiecesL],
  OutPieces =.. [outPieces|OutPiecesL],
	GameState =.. [gameState,Board,UnusedPieces,OutPieces,Player].