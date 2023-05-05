%Damariz Licea Carrisoza A01369045
%Ricardo Adolfo Férnandez Alvarado A01704813
%Actividad 5.1 Programación Lógica 


%1
lasto([X], X):-!.
lasto([_|T], X) :- lasto(T, X).


%2
butlasto([_], []).
butlasto([X|Xs], [X|Ys]) :- butlasto(Xs, Ys),!.

%3
enlisto([], []).
enlisto([X|Xs], [[X]|Ys]) :-
    enlisto(Xs, Ys).
%4
duplicateo([], []).
duplicateo([X|Xs], [X,X|Ys]) :-
    duplicateo(Xs, Ys).

%5
removeo(X, [X|Xs], Xs).
removeo(X, [Y|Xs], [Y|Ys]) :-
    removeo(X, Xs, Ys),!.
%6
reverseo(L1,L2):-reverseo(L1,[],L2).
reverseo([],L,L).
reverseo([X|Xs],L2,L3):-reverseo(Xs,[X|L2],L3),!.

%7
palindromeo(X) :- reverseo(X, X).

%8
rotateo([H|T], Result) :-
    append(T, [H], Result),!.

%9
evensizeo([]). :- discontiguous evensizeo/1.
oddsizeo([_]). :- discontiguous oddsizeo/1.
evensizeo([_|T]) :- oddsizeo(T).
oddsizeo([_|T]) :- evensizeo(T).

%10
splito([], [], []).
splito([X], [X], []).
splito([X,Y|Xs], [X|Ys], [Y|Zs]) :-
    splito(Xs, Ys, Zs),!.

%11
swappero(_, _, [], []):-!.
swappero(A, B, [A|Xs], [B|Ys]) :-
    swappero(A, B, Xs, Ys),!.
swappero(A, B, [B|Xs], [A|Ys]) :-
    swappero(A, B, Xs, Ys),!.
swappero(A, B, [X|Xs], [X|Ys]) :-
    X \= A,
    X \= B,  
    swappero(A, B, Xs, Ys),!.
    
%12
equalo([]).
equalo([_]):-!.
equalo([X|Xs]) :-
    equalo(Xs),
    member(X, Xs),!.


%13
subseto([], _).
subseto([X|Xs], Ys) :-
    member(X, Ys),
    subseto(Xs, Ys),!.

%14
compresso([], []).
compresso([X], [X]).
compresso([X,X|Xs], Ys) :-
    compresso([X|Xs], Ys),!.
compresso([X,Y|Xs], [X|Ys]) :-
    X \= Y,
    compresso([Y|Xs], Ys),!.










