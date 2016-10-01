#lang racket/base

(require racket/place/distributed
         ;racket/class
         racket/place
         racket/runtime-path
         )
;(require "doubler.rkt")

(define HOSTS (list "localhost" "landing" "gracer"))
(define NUM-PLACES 2)
(define-runtime-path doubler-path "doubler.rkt")

(provide main)

(define (main)
  #|
  (define nodes
    (for/list ([h HOSTS])
      (spawn-remote-racket-node h #:listen-port 6344)))
  (define allplcs
    (for/fold ([aps null])
              ([n nodes])
      (append (for/list ([i (in-range NUM-PLACES)])
                (supervise-place-at n doubler-path 'main))
              aps)))
|#
  (define allplcs
    (for/list ([i 4])
      (dynamic-place "doubler.rkt" 'main)))

  ;(message-router
  ; node
  (for ([i (in-range (length allplcs))]
        [p allplcs])
    (place-channel-put p 'init)
    (place-channel-put p i))
  (time
   (for ([i (in-range (length allplcs))]
         [p allplcs])
     (place-channel-put p 'slow)
     (place-channel-put p i)
     )
   (printf "~a\n"
           (for/list ([p allplcs])
             (place-channel-get p)))
   )
  
  (for ([p allplcs]) (place-channel-put p 'quit))
  (map place-wait allplcs)

  ;(for ([n nodes]) (node-send-exit n))

  )

