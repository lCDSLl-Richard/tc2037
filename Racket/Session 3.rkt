#lang racket

(define lst '(1 2 3 4 5 6 7 8 9 10))

(define redux-alt
  (lambda (lst fn)
    (cond
      [(empty? lst) '()]
      [(fn (first lst)) (cons (first lst)
                              (redux-alt (rest lst) fn))]
      [else (redux-alt (rest lst) fn)])))


(define map-alt
  (lambda (lst fn)
    (cond
      [(empty? lst) '()]
      [else (cons (fn (first lst))
                  (map-alt (rest lst) fn))])))