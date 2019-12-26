:- use_module(library(plunit)).
:- use_module(tictactoe).

:- begin_tests(tictactoe).

simulate(Moves, FinalState, Winner) :-
  initial_state(S0),
  foldl(call, Moves, S0, FinalState),
  win(FinalState, Winner),
  !.

test(play) :-
  Moves = [
    play("X", middle-center),
    play("O", top-right),
    play("X", top-left),
    play("O", middle-right),
    play("X", bottom-right)
  ],
  simulate(Moves, FinalState, Winner),

  assertion(FinalState == [
    ["X", " ", "O"],
    [" ", "X", "O"],
    [" ", " ", "X"]
  ]),
  assertion(Winner == "X").

:- end_tests(tictactoe).
