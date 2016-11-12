#lang racket/base

(require racket/place/distributed
         ;racket/class
         racket/place
         racket/runtime-path
         )

(require "rpc-doubler.rkt"
         "superfluous.rkt")

(define HOSTS ;(list "dweller" "landing" "gracer")
  (list "landing")
  )
(define NUM-PLACES 2)
(define-runtime-path doubler-path "rpc-doubler.rkt")
(define *worker-nodes* null)
(define *workers* null)

;(provide main)

(define (init-worker i node)
  (let ([awp (supervise-place-at node doubler-path 'make-rpc-doubler)])
    (printf "Initialized worker ~a purporting to be ~a~%" i (rpc-doubler-init awp i))
    awp))


(define (init-workers!)
  ;#|
  (set! *worker-nodes*
    (for/list ([h HOSTS])
      (spawn-remote-racket-node h #:listen-port 6344)))
  (set! *workers*
    (for/fold ([aps null])
              ([n *worker-nodes*])
      (append (for/list ([i (in-range NUM-PLACES)])
                ;(supervise-place-at n doubler-path 'main)
                (init-worker i n)
                )
              aps)))
  ;|#
  )
  #|
  (define allplcs
    (for/list ([i 4])
      (dynamic-place "doubler.rkt" 'main)))
|#
  ;(message-router
  ; node
  #|
  (for ([i (in-range (length allplcs))]
        [p allplcs])
    (place-channel-put p 'init)
    (place-channel-put p i)
    (printf "Initialized worker ~a purporting to be ~a~%" i (place-channel-get p)))
    |#


;(define (main)
(module+ main
  (init-workers!)
  (time
   (for/list ([i (in-range (length *workers*))]
              [p *workers*])
     (rpc-doubler-slow-double p i)
     )
   )
  
  ;(for ([p *workers*]) (place-channel-put p 'quit))
  ;(map place-wait *workers*)

  (for ([n *worker-nodes*]) (node-send-exit n))

  )





