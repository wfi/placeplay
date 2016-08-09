#lang racket/base
(require ;;racket/match
         racket/place/define-remote-server)

(define-named-remote-server doubler-server
  ;(define-state h (make-hash))

  (define-rpc (double n)
    (* n 2))
  
  (define-rpc (slow-double n)
    (sleep 4)
    (* n 2))

  #|
  (define-cast (hello)
    (printf "Hello from define-cast\n")
    (flush-output))
  |#

  )
