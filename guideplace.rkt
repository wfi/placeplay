#lang racket


(provide main)
 
(define (any-double? l)
  (for/or ([i (in-list l)])
    (for/or ([i2 (in-list l)])
      (sleep 1)
      (= i2 (* 2 i)))))

(define (send-hello dest-ch placeid)
  (place-channel-put dest-ch (format "Hello from ~a" placeid)))

(define (main)
  (define p1
    (place ch
           (define myself (place-channel-get ch))
           ;(place-channel-put ch ch)
           (define other-place (place-channel-get ch))
           (send-hello other-place myself)
           (define msg-from-other (place-channel-get other-place))
           (place-channel-put ch (format "~a rcvd from other: ~s~%" myself msg-from-other))))
  (define p2
    (place ch
           (define myself (place-channel-get ch))
           ;(place-channel-put ch ch)
           (define other-place (place-channel-get ch))
           (send-hello other-place myself)
           (define msg-from-other (place-channel-get other-place))
           (place-channel-put ch (format "~a rcvd from other: ~s~%" myself msg-from-other))))
  
  (let-values ([(ch1 ch2) (place-channel)])
    (place-channel-put p1 1)
    (place-channel-put p2 2)
    ;(define p2-ch (place-channel-get p2))
    (place-channel-put p1 ch2)
    (place-channel-put p2 ch1)
  
    (printf "1 gets: ~a~%" (place-channel-get p1))
    (printf "2 gets: ~a~%" (place-channel-get p2))
    )
  
  )