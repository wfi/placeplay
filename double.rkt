#lang racket
 
(provide main)
 
(define (any-double? l)
  (for/list ([i (in-list l)])
    (for/list ([i2 (in-list l)]
               #:when (= i2 (* 2 i)))
      (list i i2))))
 
(define (main)
  (define p
    (place ch
      (define l (place-channel-get ch))
      (define l-double? (any-double? l))
      (place-channel-put ch l-double?)))
 
  (place-channel-put p (list 1 2 4 8))
 
  (place-channel-get p))
