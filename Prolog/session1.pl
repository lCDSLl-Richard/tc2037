male(caos).
male(erbo).
male(urano).
male(eter).
male(crios).
male(cronos).
male(ceo).
male(oceano).
male(japeto).
male(hiperion).
male(poseidon).
male(hades).
male(zeus).
male(helios).
male(eros).

female(nix).
female(gea).
female(hemera).
female(temis).
female(rea).
female(febe).
female(tetis).
female(tia).
female(mnemosine).
female(leto).
female(hestia).
female(hera).
female(demeter).
female(pleyone).
female(metis).
female(climene).
female(selene).
female(eos).
female(afrodita).

father(caos, erbo).
father(caos, urano).
father(caos, eter).
father(caos, nix).
father(caos, gea).
father(caos, hemera).
father(urano, temis).
father(urano, crios).
father(urano, cronos).
father(urano, rea).
father(urano, febe).
father(urano, ceo).
father(urano, oceano).
father(urano, tetis).
father(urano, japeto).
father(urano, tia).
father(urano, hiperion).
father(urano, mnemosine).
father(urano, afrodita).
father(ceo, leto).
father(cronos, hestia).
father(cronos, hades).
father(cronos, poseidon).
father(cronos, hera).
father(cronos, zeus).
father(cronos, demeter).
father(oceano, pleyone).
father(oceano, metis).
father(oceano, climene).
father(hiperion, helio).
father(hiperion, selene).
father(hiperion, eos).

mother(gea, temis).
mother(gea, crios).
mother(gea, cronos).
mother(gea, rea).
mother(gea, febe).
mother(gea, ceo).
mother(gea, oceano).
mother(gea, tetis).
mother(gea, japeto).
mother(gea, tia).
mother(gea, hiperion).
mother(gea, mnemosine).
mother(febe, leto).
mother(rea, hestia).
mother(rea, hades).
mother(rea, poseidon).
mother(rea, hera).
mother(rea, zeus).
mother(rea, demeter).
mother(tetis, pleyone).
mother(tetis, metis).
mother(tetis, climene).
mother(tia, helio).
mother(tia, selene).
mother(tia, eos).
mother(afrodita, eros).

parent(X, Y) :- mother(X, Y) ; father(X, Y).

son(X, Y) :- male(X) , parent(Y, X).
daughter(X, Y) :- female(X) , parent(Y, X).

sibling(X, Y) :- father(F, X) , father(F, Y) ,
                  mother(M, X) , mother(M, Y) , 
                  X \== Y.

ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z) , ancestor(Z, Y).

descendant(X, Y) :- ancestor(Y, X).
 
% ALGEBRA BOOLEANA

and(0, 0, 0).
and(0, 1, 0).
and(1, 0, 0).
and(1, 1, 1).

or(0, 0, 0).
or(0, 1, 1).
or(1, 0, 1).
or(1, 1, 1).

not(0, 1).
not(1, 0).

nand(A, B, R) :- and(A, B, R1), not(R1, R).

nor(A, B, R) :- or(A, B, R1), not(R1, R).

circuit1(W, X, Y, Z, R) :- 
  and(W, X, O1),
  not(Y, O2),
  or(X, O2, O3),
  and(O1, O3, O4),
  or(Y, Z, O5),
  not(O5, O6),
  or(O4, O6, R).

