#lang racket/base

(require racket/place/define-remote-server)

(require "superfluous.rkt")

(current-directory "/home/iba/code/placeplay/")

(define (base-double n)
  (* n 2))

(define-remote-server rpc-doubler
  (define-state myid -1)
  (define-state myout 'not-initialized-yet)

  (define-rpc (init id)
    (set! myid id)
    (set! myout (open-output-file (string-append "worker-" (number->string id) ".log") #:exists 'replace))
    myid)

  (define-rpc (double n)
    (cons myid (base-double n)))

  (define-rpc (slow-double n)
    ;(printf "In slow-double of worker~%")
    (sleep 4)
    (cons myid (base-double n)))

  )


#|
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

  
  (define-cast (hello)
    (printf "Hello from define-cast\n")
    (flush-output))
  

  )
|#