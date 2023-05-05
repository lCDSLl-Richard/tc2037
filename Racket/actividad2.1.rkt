#lang racket

;;; Actividad 2.1
;;; Ricardo Fernandez
;;; A01704813
;;; Damariz Licea
;;; A01369045
;;; 06-03-2023

;;; E1) farenheit-to-celcius: number -> number
(define farenheit-to-celcius
  (lambda (farenheit)
    (/ (* 5 (- farenheit 32)) 9)))

;;; E2) sign: number -> number
(define sign
  (lambda (n)
    (cond
      [(= 0 n) 0]
      [(> n 0) 1]
      [else -1]
      )))

;;; E3) roots: number number number -> number
(define roots
  (lambda (a b c)
    (cond
      [(= (- (* b b) (* 4 a c)) 0) (/ (- 0 b) (* 2 a))]
      [(< (- (* b b) (* 4 a c)) 0) 'NoSolution]
      [else (/ (+ (- 0 b) (sqrt (- (* b b) (* 4 a c)))) (* 2 a))])))

;;; E4) BMI: number number -> token
(define BMI
  (lambda (weight height)
    (cond
      [(< (/ weight (* height height)) 20) 'underweight]
      [(< (/ weight (* height height)) 25) 'normal]
      [(< (/ weight (* height height)) 30) 'obese1]
      [(< (/ weight (* height height)) 40) 'obese2]
      [else 'obese3])))

;;; E5) factorial: number -> number
(define factorial
  (lambda (n)
    (cond
      [(= n 0) 1]
      [else (* n (factorial (- n 1)))])))

;;; E6) duplicate: lst -> lst
(define duplicate
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [else (append (list (first lst) (first lst)) (duplicate (rest lst)))])))

;;; E7) pow: number number -> number
(define pow
  (lambda (n power)
    (cond
      [(= power 0) 1]
      [else (* n (pow n (- power 1)))])))

;;; E8) fib: number -> number
(define fib
  (lambda (n)
    (cond
      [(= n 0) 0]
      [(= n 1) 1]
      [(= n 2) 1]
      [else (+ (fib (- n 1)) (fib (- n 2)))])))

;;; E9) enlist: lst -> lst
(define enlist
  (lambda (lst)
    (map list lst)))

;;; E10) positives: lst -> lst
(define positives
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [(> (first lst) 0) (cons (first lst) (positives (rest lst)))]
      [else (positives (rest lst))])))

;;; E11) add-list: lst -> number
(define add-list
  (lambda (lst)
    (cond
      [(empty? lst) 0]
      [else (+ (first lst) (add-list (rest lst)))])))

;;; E12) invert-pairs: lst -> lst
(define invert-pairs
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [else (cons (append (rest (first lst))
                          (list (first (first lst))))
                  (invert-pairs (rest lst)))])))

;;; E13) list-of-symbols: lst -> bool
(define list-of-symbols?
  (lambda (lst)
    (cond
      [(empty? lst) #t]
      [(number? (first lst)) #f]
      [else (list-of-symbols? (rest lst))])))

;;; E14) swapper: token token lst -> lst
(define swapper
  (lambda (a b lst)
    (cond
      [(empty? lst) '()]
      [(equal? (first lst) a) (cons b (swapper a b (rest lst)))]
      [(equal? (first lst) b) (cons a (swapper a b (rest lst)))]
      [else (cons (first lst) (swapper a b (rest lst)))])))

;;; E15) dot-product: lst lst -> number
(define dot-product
  (lambda (a b)
    (cond
      [(or (empty? a) (empty? b)) 0]
      [else (+ (* (first a) (first b)) (dot-product (rest a) (rest b)))])))

;;; E16) average: lst -> number
(define average
  (lambda (lst)
    (/ (add-list lst) (length lst))))

;;; E17) standard-deviation: lst -> number
(define variance
  (lambda (lst avg)
    (cond
      [(empty? lst) 0]
      [else (+ (pow (- (first lst) avg) 2) (variance (rest lst) avg))])))

(define standard-deviation
  (lambda (lst)
    (cond
      [(empty? lst) 0]
      [else (sqrt (/ (variance lst (average lst)) (length lst)))])))

;;; E18) replic: number lst -> lst
(define replic-helper
  (lambda (n token)
    (cond
      [(= n 1) (list token)]
      [else (cons token (replic-helper (- n 1) token))])))

(define replic
  (lambda (n lst)
    (cond
      [(empty? lst) '()]
      [(= n 0) '()]
      [else (append (replic-helper n (first lst)) (replic n (rest lst)))])))

;;; E19) expand: lst -> lst
(define expand-helper
  (lambda (lst i)
    (cond
      [(empty? lst) '()]
      [else (append (replic-helper i (first lst)) (expand-helper (rest lst) (+ i 1)))])))

(define expand
  (lambda (lst)
    (expand-helper lst 1)))

;;; E20) binary: number -> lst
(define binary
  (lambda (n)
    (cond
      [(= n 0) '()]
      [else (append (binary (quotient n 2)) (list (remainder n 2)))])))