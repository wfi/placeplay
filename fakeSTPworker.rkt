#lang racket/base
(require racket/match
         racket/place/define-remote-server)

(define (base-double n)
  (* n 2))

(define-named-remote-server fakeSTPworker-server
  (define-state last-result 0)
  (define-state ready #f)

  (define-rpc (get-last)
    last-result)

  (define-rpc (ready?)
    ready)

  (define-rpc (double n)
    (base-double n))
  
  (define-rpc (slow-double n)
    (sleep 4)
    (base-double n))
  
  (define-cast (async-slow-double n)
    ;(printf "Hello from define-cast\n")
    ;(flush-output)
    (set! ready #f)
    (sleep 1)
    (set! last-result (base-double n))
    (set! ready #t))
  

  )
