#lang racket/base

(require racket/set
         racket/place/distributed
         racket/class
         racket/place
         racket/runtime-path
         ;
         racket/match
         racket/place/define-remote-server)

;(define whoiam -1)


(define-named-remote-server place-worker
  (define-state whoiam -1)
  (define-rpc (setid id)
    (set! whoiam id)
    (format "worker ~a: sets id ~a~%" whoiam id))
  (define-rpc (echo n)
    (format "worker ~a: echoes ~a~%" whoiam n))
  (define-rpc (incr n)
    (format "worker ~a: incrs ~a~%" whoiam (add1 n)))
  (define-cast (hello)
    (printf "hello from place-worker's define-cast ~a\n" whoiam)
    (flush-output)))

;(provide place-main)
#|
(define (place-main ch)
  (let ([my-id (place-channel-get ch)])
    ;(displayln (string-append "place-worker prints " (number->string my-id)))
    (set! whoiam my-id)
    (place-channel-put ch (format "other-place reports: ~a~%" whoiam))))
|#