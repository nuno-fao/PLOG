main_menu :-
    print_main_menu,
    retract(controller(0,_X)),
    retract(controller(1,_X1)),
    write('Insert your option: '),
    read(Input),clear_buffer,
    manage_game_mode(Input).

manage_game_mode(1):-
    assert(controller(0,'P')),
    assert(controller(1,'P')).
manage_game_mode(2):-
    assert(controller(0,'P')),
    assert(controller(1,'AI')),
    difficulty_menu.
manage_game_mode(3):-
    assert(controller(0,'AI')),
    assert(controller(1,'AI')),
    difficulty_menu.
manage_game_mode(0) :-
    assert(controller(0,'E')),
    assert(controller(1,'E')),
    write('\nExiting...\n\n').
manage_game_mode(Number) :-
    (\+ number(Number); Number<0 ; Number>3),
    write('Invalid option!\n\n'), 
    read(Input),clear_buffer,
    manage_game_mode(Input).


print_main_menu :-
    nl,
    write(' _______________________________________________________________________ '),nl,
    write('|                                                                       |'),nl,
    write('|                                 GAUSS                                 |'),nl,
    write('|                                                                       |'),nl,
    write('|               -----------------------------------------               |'),nl,
    write('|                                                                       |'),nl,
    write('|                        What gamemode do you want?                     |'),nl,
    write('|                                                                       |'),nl,
    write('|                          1. Player vs Player                          |'),nl,
    write('|                                                                       |'),nl,
    write('|                          2. Player vs Computer                        |'),nl,
    write('|                                                                       |'),nl,
	write('|                          3. Computer vs Computer                      |'),nl,
    write('|                                                                       |'),nl,
    write('|                          0. Exit                                      |'),nl,
    write('|                                                                       |'),nl,
    write(' _______________________________________________________________________ '),nl,nl.


difficulty_menu :-
    print_difficulty,
    retract(difficulty(_Difficulty)),
    write('Insert your option: '),
    read(InputD),clear_buffer,
    manage_difficulty(InputD).

print_difficulty :-
    nl,
    write(' _______________________________________________________________________ '),nl,
    write('|                                                                       |'),nl,
    write('|                  What difficulty do you want for the AI?              |'),nl,
    write('|                                                                       |'),nl,
    write('|                                1. Easy                                |'),nl,
    write('|                                                                       |'),nl,
	write('|                                2. Hard                                |'),nl,
    write('|                                                                       |'),nl,
    write(' _______________________________________________________________________ '),nl,nl.

manage_difficulty(1):-
    assert(difficulty('easy')).
manage_difficulty(2):-
    assert(difficulty('hard')).
manage_difficulty(_):-
    (\+ number(Number); Number<1 ; Number>2),
     write('Invalid option!\n\n'), 
    read(Input),clear_buffer,
    manage_difficulty(Input).