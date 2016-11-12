#lang racket

(require "superfluous.rkt")

(provide main
         slow-double
         double)

(define myid -1)
(define myout 'not-initialized-yet)

(define (base-double n)
  (* n 2))

(define (double pch)
  (place-channel-put pch (cons myid (base-double (place-channel-get pch)))))

(define (slow-double pch)
  ;(printf "In slow-double of worker~%")
  (sleep 4)
  (place-channel-put pch (cons myid (base-double (place-channel-get pch)))))

(define (main pch)
   (case (place-channel-get pch)
     [(init) (set! myid (place-channel-get pch))
             (set! myout (open-output-file (string-append "worker-" (number->string myid) "-"
                                                          (number->string (first (with-input-from-file "tmp/foo.txt" read)))
                                                          ".log")
                                           #:exists 'replace))
             (place-channel-put pch myid)
             (fprintf myout "done initializing worker ~a~%" myid)
             (main pch)]
     [(double) (double pch)
               (main pch)]
     [(slow) (slow-double pch)
             (main pch)]
     [(quit) (close-output-port myout)
             (place-channel-put pch 'done)]
     [else (place-channel-put pch 'unknown-message)
           (main pch)]))
  

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