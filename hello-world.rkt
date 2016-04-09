#lang racket/base
(require racket/place/distributed
         racket/place)

(provide hello-world)

(define (hello-world)
  (place ch
    ;(printf "hello-world received: ~a\n"  (place-channel-get ch))
    ;(define HW "Hello World")
    ;(place-channel-put ch (format "hello-world received ~a\n" (place-channel-get ch)))
    (place-channel-put ch "Hellow World\n")
    ;(printf "hello-world sent: ~a\n" HW)
    ;(printf "hellow-world sent: Hello World\n")
    ))


(module+ main
  (define-values (node pl)
    (spawn-node-supervise-place-at 
      "localhost" ;; works with localhost but not human
      #:listen-port 6344
      (quote-module-path "..")
      'hello-world
      #:thunk #t))

  (message-router
    node
    (after-seconds 2
      (*channel-put pl "What about this?")
      (printf "message-router received: ~a\n" (*channel-get pl)))

    (after-seconds 6 
      (exit 0))))
