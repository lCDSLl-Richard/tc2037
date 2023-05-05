#lang racket
(define attendees
  (lambda (ticket-price)
    (+ 120
       (* (/ 15 .1) (- 5 ticket-price)))))

(define revenue
  (lambda (ticket-price)
    (* (attendees ticket-price) ticket-price)))

(define cost
  (lambda (ticket-price)
    (+ 180
       (* .04 (attendees ticket-price)))))

(define earnings
  (lambda (ticket-price)
    (- (revenue ticket-price) (cost ticket-price))))

(define best-ticket-price
  (lambda (ticket-price best)
    (cond
      [(> (earnings ticket-price) best) (best-ticket-price (- ticket-price .1) (earnings ticket-price))]
      [else ticket-price])))


(define size
  (lambda (lst)
    (cond
      [(empty? lst) 0]
      [else (+ 1 (size (rest lst)))])))


(define sum-list
  (lambda (lst acum)
    (cond
      [(empty? lst) acum]
      [else (sum-list (rest lst) (+ acum (first lst)))])))

(define max-list
  (lambda (lst max)
    (cond
      [(empty? lst) max]
      [(> (first lst) max) (max-list (rest lst) (first lst))]
      [else (max-list (rest lst) max)])))







