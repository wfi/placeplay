#lang racket/base
 
(require racket/place/distributed
         racket/class
         racket/place
         racket/runtime-path
         "doubler.rkt")

(define-runtime-path doubler-path "doubler.rkt")


(provide main)

(define (callit conn n)
  (doubler-server-double conn n))

(define (main)
  (define node-a (spawn-remote-racket-node 
                        "localhost" 
                        #:listen-port 6346))
  (define node-b (spawn-remote-racket-node 
                        "localhost" 
                        #:listen-port 6347))
  (define dp-a (supervise-place-at 
                node-a
                #:named 'doubler-server 
                doubler-path 
                'make-doubler-server))
  (define db-b (supervise-place-at 
                node-b 
                #:named 'doubler-server
                doubler-path 
                'make-doubler-server))
  #|
  (define bank-place  (supervise-place-at 
                        remote-node bank-path 
                        'make-bank))
  |#

  ;(message-router
   ; remote-node

    #|
    (after-seconds 4
      (displayln (bank-new-account bank-place 'user0))
      (displayln (bank-add bank-place 'user0 10))
      (displayln (bank-removeM bank-place 'user0 5)))
    |#
    
    ;(after-seconds 2
      (define c (connect-to-named-place node-a 
                                        'doubler-server))
      (define d (connect-to-named-place node-b
                                        'doubler-server))
      ;(tuple-server-hello c)
      ;(tuple-server-hello d)
      ;(displayln (doubler-server-slow-double c 3))
      (displayln (callit c 3))
      ;(displayln (doubler-server-slow-double d 4))
      (displayln (callit d 4))
     ; )

    ;(after-seconds 12
      (node-send-exit node-a)
      (node-send-exit node-b)
      ;)
  #|
    (after-seconds 14
      (exit 0))
|#
  ;)
)


