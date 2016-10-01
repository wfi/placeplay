#lang racket

(provide main
         slow-double
         double)

(define myid -1)

(define (base-double n)
  (* n 2))

(define (double pch)
  (place-channel-put pch (cons myid (base-double (place-channel-get pch)))))

(define (slow-double pch)
  (sleep 4)
  (place-channel-put pch (cons myid (base-double (place-channel-get pch)))))

(define (main pch)
  (case (place-channel-get pch)
    [(init) (set! myid (place-channel-get pch)) (main pch)]
    [(double) (double pch) (main pch)]
    [(slow) (slow-double pch) (main pch)]
    [(quit) 'done]
    [else 'unknown-message]))
  

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