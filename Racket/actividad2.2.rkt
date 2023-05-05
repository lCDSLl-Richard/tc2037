#lang racket

;;; Actividad 2.2
;;; Ricardo Fernandez
;;; A01704813
;;; Damariz Licea
;;; A01369045
;;; 15-03-2023

;;; E1) insert: number lst -> lst
(define insert
  (lambda (n lst)
    (cond
      [(empty? lst) (cons n '())]
      [(<= n (first lst)) (cons n lst)]
      [else (cons (first lst) (insert n (rest lst)))])))

;;; E2) insertion-sort: lst -> lst
(define insertion-sort
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [else (insert (first lst) (insertion-sort (rest lst)))])))

;;; E3) rotate-left: n lst -> lst
(define rotate-helper
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [else (append (rest lst) (list (first lst)))])))

(define rotate-left
  (lambda (n lst)
    (cond
      [(= n 0) lst]
      [(empty? lst) '()]
      [(> n 0) (rotate-left (- (remainder n (length lst)) 1) (rotate-helper lst))]
      [else (rotate-left (- (+ (remainder n (length lst)) (length lst)) 1) (rotate-helper lst))])))

;;; E4) prime-factors: number -> lst
(define prime-factors-helper
  (lambda (n i)
    (cond
      [(= n 1) '()]
      [(= (remainder n i) 0) (cons i (prime-factors-helper (/ n i) i))]
      [else (prime-factors-helper n (+ i 1))])))

(define prime-factors
  (lambda (n)
    (prime-factors-helper n 2)))

;;; E5) gcd: number number -> number
(define gcd
  (lambda (a b)
    (cond
      [(= b 0) a]
      [else (gcd b (remainder a b))])))

;;; E6) deep-reverse: lst -> lst
(define deep-reverse
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [(list? (first lst)) (append (deep-reverse (rest lst)) (list (deep-reverse (first lst))))]
      [else (append (deep-reverse (rest lst)) (list (first lst)))])))

;;; E7) insert-everywhere: token lst -> lst
(define insert-at
  (lambda (token lst i)
    (cond
      [(= i (length lst)) (append lst (list token))]
      [(= i 0) (cons token lst)]
      [else (cons (first lst) (insert-at token (rest lst) (- i 1)))])))

(define insert-everywhere-helper
  (lambda (token lst i)
    (cond
      [(empty? lst) (list (list token))]
      [(= i (length lst)) (list (insert-at token lst i))]
      [else (cons (insert-at token lst i) (insert-everywhere-helper token lst (+ i 1)))])))

(define insert-everywhere
  (lambda (token lst)
    (insert-everywhere-helper token lst 0)))

;;; E8) pack: lst -> lst
(define pack-helper
  (lambda (lst aPack res)
    (cond
      [(and (empty? lst) (empty? aPack)) (list)]
      [(empty? lst) (append res (list aPack))]
      [(empty? aPack) (pack-helper (rest lst) (list (first lst)) res)]
      [(eq? (first aPack) (first lst))
       (pack-helper (rest lst) (cons (first lst) aPack) res)]
      [else (pack-helper lst '() (append res (list aPack)))])))

(define pack
  (lambda (lst)
    (pack-helper lst (list) (list))))

;;; E9) compress: lst -> lst
(define compress
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [(empty? (rest lst)) (list (first lst))]
      [(equal? (first lst) (first (rest lst))) (compress (rest lst))]
      [else (cons (first lst) (compress (rest lst)))])))

;;; E10) encode: lst -> lst
(define encode-helper
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [else (cons (list (length (first lst)) (first (first lst))) (encode-helper (rest lst)))])))

(define encode
  (lambda (lst)
    (encode-helper (pack lst))))

;;; E11) encode-modified: lst -> lst
(define encode-modified-helper
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [(= (first (first lst)) 1) (cons (first (rest (first lst))) (encode-modified-helper (rest lst)))]
      [else (cons (first lst) (encode-modified-helper (rest lst)))])))

(define encode-modified
  (lambda (lst)
    (encode-modified-helper (encode lst))))


;;; E12) decode: lst -> lst
(define replic-helper
  (lambda (n token)
    (cond
      [(= n 1) (list token)]
      [else (cons token (replic-helper (- n 1) token))])))

(define decode
  (lambda (lst)
    (cond
      [(empty? lst) '()]
      [(list? (first lst)) (append (replic-helper (first (first lst)) (first (rest (first lst)))) (decode (rest lst)))]
      [else (cons (first lst) (decode (rest lst)))])))

;;; E13) args-swap: fn(a b) -> fn(b a)
(define args-swap
  (lambda (fn)
    (lambda(x y)
      (fn y x))))

;;; E14) there-exists-one?: lst -> bool
;;; (define there-exists-one?-helper
;;;   (lambda (condition lst found)
;;;     (cond
;;;       [(and (empty? lst) found) #t]
;;;       [(empty? lst) #f]
;;;       [(and (condition (first lst)) found) #f]
;;;       [(condition (first lst)) (there-exists-one?-helper condition (rest lst) #t)]
;;;       [else (there-exists-one?-helper condition (rest lst) #f)])))

(define there-exists-one?-helper
  (lambda (condition lst found)
    (cond
      [(and (empty? lst) found) #t]
      [(empty? lst) #f]
      [(and (condition (first lst)) found) #f]
      [(condition (first lst)) (there-exists-one?-helper condition (rest lst) #t)]
      [else (there-exists-one?-helper condition (rest lst) found)])))

(define there-exists-one?
  (lambda (condition lst)
    (there-exists-one?-helper condition lst #f)))

;;; E15) linear-search: lst token condition -> bool/number
(define linear-search-helper
  (lambda (lst token condition index)
    (cond
      [(empty? lst) #f]
      [(condition token (first lst)) index]
      [else (linear-search-helper (rest lst) token condition (+ index 1))])))

(define linear-search
  (lambda (lst token condition)
    (linear-search-helper lst token condition 0)))

;;; E16) deriv: fn -> fn
(define deriv
  (lambda (fn h)
    (lambda (x)
      (/ (- (fn (+ x h)) (fn x)) h))))

(define f (lambda (x) (* x x x)))
(define df (deriv f 0.001))
(define ddf (deriv df 0.001))
(define dddf (deriv ddf 0.001))

;;; E17) newton: fn n -> n)
(define (memo f)
  (let ([cash (make-hash)])
    (lambda args
      (cond
        [(hash-has-key? cash args) (hash-ref cash args)]
        [else
         (let ([result (apply f args)])
           (hash-set! cash args result)
           result)]))))

(define-syntax-rule (memo! f) (set! f (memo f)))

(define newton
  (lambda (fn n)
    (cond
      [(= n 0) 0]
      [else (- (newton fn (- n 1)) (/ (fn (newton fn (- n 1))) ((deriv fn 0.001) (newton fn (- n 1)))))])))

(memo! newton)

;;; E18) integral: n n n fn -> n