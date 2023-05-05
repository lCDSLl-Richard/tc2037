fact(1, 1).
fact(N, X) :-
  X > 1,
  X1 is X - 1,
  fact(N1, X1),
  N is X * N1.

fib(0, 0).
fib(1, 1).
fib(N, X) :-
  X > 1,
  X1 is X - 1,
  X2 is X - 2,
  fib(N1, X1),
  fib(N2, X2),
  N is N1 + N2.