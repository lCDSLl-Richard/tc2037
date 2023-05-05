fact_tail(1, Res, Res) :- !.
fact_tail(X, Res, Acc) :-
  NewX is X - 1,
  NewAcc is Acc * X,
  fact_tail(NewX, Res, NewAcc).

sum(End, End, End) :- !.
sum(Start, End, Result) :-
  Start < End,
  NewStart is Start + 1,
  sum(NewStart, End, PrevResult),
  Result is PrevResult + Start.

sum_tail(End, End, Acc, Result) :- 
  Result is Acc + End,
  !.
sum_tail(Start, End, Acc, Result) :-
  Start < End,
  NewAcc is Acc + Start,
  NewStart is Start + 1,
  sum_tail(NewStart, End, NewAcc, Result).

fib_head(1, 1) :- !.
fib_head(2, 1).
fib_head(X, Res) :-
  X > 2,
  X1 is X - 1,
  X2 is X - 2,
  fib_head(X1, R1),
  fib_head(X2, R2),
  Res is R1 + R2.

fib_tail(1, _, Result, Result).
fib_tail(2, _, Result, Result).
fib_tail(N, A, B, Result) :- 
  N > 2,
  NewN is N - 1,
  C is A + B,
  fib_tail(NewN, B, C, Result).

% LISTS %

first([Head | _], Head).

rest([_ | Tail], Tail).

len([], 0).
len([_ | Tail], Result) :-
  len(Tail, R1),
  Result is R1 + 1.

sum_list([], 0).
sum_list([Head | Tail], Result) :-
  sum_list(Tail, R1),
  Result is Head + R1.

find_list([Head | _], Head) :- !.
find_list([Head | Tail], X) :-
  Head \== X,
  find_list(Tail, X).

add2([], []).
add2([Head | Tail], [NewHead | NewTail]) :-
  NewHead is Head + 2,
  add2(Tail, NewTail).

my_append([], L2, L2).
my_append(L1, [], L1).
my_append([Head | Tail], L2, [Head | NewTail]) :-
  my_append(Tail, L2, NewTail).

my_merge([], L2, L2).
my_merge(L1, [], L1).
my_merge([H1 | T1], [H2 | T2], [H1 | Temp]) :-
  H1 < H2,
  my_merge(T1, [H2 | T2], Temp).
my_merge([H1 | T1], [H2 | T2], [H2 | Temp]) :-
  my_merge([H1 | T1], T2, Temp).

split([], [], []).
split([X], [X], []).
split([Head | Tail], [Head | R1], R2) :-
  split(Tail, R2, R1).

merge_sort([], []) :- !.
merge_sort([X], [X]) :- !.
merge_sort(Unsorted, Sorted) :-
  split(Unsorted, L1, L2),
  merge_sort(L1, S1),
  merge_sort(L2, S2),
  my_merge(S1, S2, Sorted), !.
