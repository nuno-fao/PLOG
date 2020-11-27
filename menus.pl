mainMenu :-
    printMainMenu,
    retract(controller(0,X)),
    retract(controller(1,X1)),
    write('Insert your option: '),
    read(Input),
    manageGamemode(Input).

manageGamemode(1):-
    assert(controller(0,'P')),
    assert(controller(1,'P')).
manageGamemode(2):-
    assert(controller(0,'P')),
    assert(controller(1,'AI')),
    difficultyMenu.
manageGamemode(3):-
    assert(controller(0,'AI')),
    assert(controller(1,'AI')),
    difficultyMenu.
manageGamemode(0) :-
    assert(controller(0,'E')),
    assert(controller(1,'E')),
    write('\nExiting...\n\n').
manageGamemode(Number) :-
    (\+ number(Number); Number<0 ; Number>3),
    write('Invalid option!\n\n'), 
    read(Input),
    manageGamemode(Input).


printMainMenu :-
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


difficultyMenu :-
    printDifficulty,
    retract(difficulty(Difficulty)),
    write('Insert your option: '),
    read(InputD),
    manageDifficulty(InputD).

printDifficulty :-
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

manageDifficulty(1):-
    assert(difficulty(easy)).
manageDifficulty(2):-
    assert(difficulty(hard)).
manageDifficulty(_):-
    (\+ number(Number); Number<1 ; Number>2),
     write('Invalid option!\n\n'), 
    read(Input),
    manageDifficulty(Input).