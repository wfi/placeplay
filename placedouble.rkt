#lang racket/base

(require racket/place/distributed
         ;racket/class
         racket/place
         racket/runtime-path
         )
;(require "doubler.rkt")

(define NUM-PLACES 4)
(define-runtime-path doubler-path "doubler.rkt")

(provide main)

(define (main)
  ;#|
  (define node (spawn-remote-racket-node "landing"
                                         #:listen-port 6344
                                         ))
  ;|#
  (define pls (for/list ([i (in-range NUM-PLACES)])
                #|
                (dynamic-place "doubler.rkt"
                               'main
                               ;#:at node
                               )
                |#
                (supervise-place-at node doubler-path 'main)
                ))
  ;(message-router
  ; node
  ;#|
  (time
   (for ([i (in-range NUM-PLACES)]
         [p pls])
     (place-channel-put p 'slow)
     (place-channel-put p i)
     )
   (printf "~a\n"
           (for/list ([p pls])
             (place-channel-get p)))
             )
  ;|#
  #|
  (time
   (for ([i (in-range NUM-PLACES)]
         [p pls])
     (place-channel-put p 'slow)
     (printf "~a\n" (place-channel-put/get p i))
     ))
  |#
  (for ([p pls]) (place-channel-put p 'quit))
  (map place-wait pls)
  
  (node-send-exit node)
  )

