#lang racket/base

(require racket/place/distributed
         racket/class
         racket/place
         racket/runtime-path
         "doubler.rkt")
(define-runtime-path doubler-path "doubler.rkt")


(provide main)

(define (main)
  (define remote-node (spawn-remote-racket-node 
                        "dweller" 
                        #:listen-port 6344))
  (define doubler-place (supervise-place-at 
                         remote-node 
                         #:named 'doubler-server 
                         doubler-path 
                         'make-doubler-server))
  #|
  (define bank-place  (supervise-place-at 
                        remote-node bank-path 
                        'make-bank))
  |#

  (message-router
    remote-node

    #|
    (after-seconds 4
      (displayln (bank-new-account bank-place 'user0))
      (displayln (bank-add bank-place 'user0 10))
      (displayln (bank-removeM bank-place 'user0 5)))
    |#
    
    (after-seconds 2
      (define c (connect-to-named-place remote-node 
                                        'doubler-server))
      (define d (connect-to-named-place remote-node 
                                        'doubler-server))
      ;(tuple-server-hello c)
      ;(tuple-server-hello d)
      (displayln (doubler-server-double c 3))
      (displayln (doubler-server-double d 4))
      )

    (after-seconds 8
      (node-send-exit remote-node))
    (after-seconds 10
      (exit 0))))


