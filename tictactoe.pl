:- module(tictatoe, [
  main/0,
  initial_state/1,
  win/2,
  play/4
]).

initial_state(S) :-
  S = [
    [" "," "," "],
    [" "," "," "],
    [" "," "," "]
  ].

coord(top, 0).
coord(left, 0).
coord(center, 1).
coord(middle, 1).
coord(bottom, 2).
coord(right, 2).
coord(t, 0).
coord(l, 0).
coord(c, 1).
coord(m, 1).
coord(b, 2).
coord(r, 2).
coord(N, N) :- integer(N), between(0, 2, N).

play(Player, CY-CX, StateIn, StateOut) :-
  coord(CX, X),
  coord(CY, Y),
  nth0(Y, StateIn, Row, OtherRows),
  nth0(X, Row, " ", OtherVals),
  nth0(X, ReplacedRow, Player, OtherVals),
  nth0(Y, StateOut, ReplacedRow, OtherRows).

valid_player(P) :- member(P, ["X", "O"]).

win([
    [P,_,_],
    [P,_,_],
    [P,_,_]
  ], P) :- valid_player(P).

win([
    [_,P,_],
    [_,P,_],
    [_,P,_]
  ], P) :- valid_player(P).

win([
    [_,_,P],
    [_,_,P],
    [_,_,P]
  ], P) :- valid_player(P).

win([
    [P,P,P],
    [_,_,_],
    [_,_,_]
  ], P) :- valid_player(P).

win([
    [_,_,_],
    [P,P,P],
    [_,_,_]
  ], P) :- valid_player(P).

win([
    [_,_,_],
    [_,_,_],
    [P,P,P]
  ], P) :- valid_player(P).

win([
    [P,_,_],
    [_,P,_],
    [_,_,P]
  ], P) :- valid_player(P).

win([
    [_,_,P],
    [_,P,_],
    [P,_,_]
  ], P) :- valid_player(P).


%% rendering

display(State, State) :-
  render(State, Out),
  nl, nl, write(Out), nl, nl, nl.

display_winner(State, State) :-
  win(State, W),
  write("Winner: "), write(W), nl, nl, nl.

render(Rows, Out) :-
  maplist(render_row, Rows, RowsOut),
  atomics_to_string(RowsOut, "\n_________\n", Out).

render_row(Row, Out) :-
  atomics_to_string(Row, " | ", Out).

instructions :-
  writeln("# Instructions"),
  nl,
  writeln("Player X and O take turns entering moves until one of them wins."),
  writeln("Valid moves are in the following format:"), nl,
  writeln("row-col."),
  nl,
  writeln("Where row and col are either:"),
  writeln("  - a number from 0 to 2"),
  writeln("  - top, left, center, middle, bottom or right"),
  writeln("  - the first char of one of the directions above"),
  nl,
  writeln("The dot at the end is required to complete a move."),
  nl,
  writeln("Use ""end."" to abort the game."),
  nl,
  true.

%% main loop

main :-
  instructions,
  initial_state(S0),
  main(S0).

main(S0) :-
  loop_read_player("X", S0, S1),
  (display_winner(S1, S1) ;
    loop_read_player("O", S1, S2),
    (display_winner(S2, S2) ; main(S2))
  ).

loop_read_player(P, S0, S1) :-
  repeat, (
    read_player(P, PX),
    play(P, PX, S0, S1)
  ;
    writeln("Invalid move."), fail
  ),
  display(S1, S1), !.

read_player(P, Pos) :-
  write("Player "), write(P), write(" move: "),
  catch(read_term(Pos, []), _, false),
  eval_move(Pos),
  true.

eval_move(Move) :-
  dif(Move, end) -> true ; halt.
