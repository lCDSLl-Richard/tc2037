#lang racket
;; Author: Ricardo Fernandez
;; Session 1
;; commenting

(define a 5)

(define fn1
  (lambda (x)
    (+ x 5)))

(define fn2
  (lambda (x y)
  (+ x y)))

(define fn3
  (lambda (x)
    (lambda(y)
      (+ x y))))

;; sum-of-squares: number number -> number

(define sum-of-squares
  (lambda (x y)
    (+ (* x x) (* y y))))

;; area-of-disk: number -> number

(define area-of-disk 
  (lambda (radius)
    (* radius radius 3.1415)))

;; area-of-ring: number number -> number
(define area-of-ring
  (lambda (outer inner)
    (- (area-of-disk outer) (area-of-disk inner))))

;; wage: number number -> number
(define wage
  (lambda (payment hours)
    (* payment hours)))


;; tax: number number -> number
(define tax
  (lambda (wage rate)
    (* wage rate)))

;; netpay: number number number -> number
(define netpay
  (lambda (payment hours rate)
    (- (wage payment hours)
        (tax (wage payment hours) rate))))

;; maximum: number number -> number
(define maximum
  (lambda (a b)
    (cond
      [(> a b) a]
      [else b])))
      
;; factorial: number -> number

(define factorial
  (lambda (n)
    (cond
      [(= n 1) 1]
      [else (* n (factorial (- n 1)))])))

;; fibo: number -> number

;; sum: number number -> number
(define sum
  (lambda (start end)
    (cond
      [(= start end) end]
      [else (+ start (sum (+ start 1) end))])))

;; gcd: number number -> number
(define gcd
  (lambda (a b)
    (cond
      [(= b 0) a]
      [else (gcd b (remainder a b))])))



