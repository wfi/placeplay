#lang racket

(require racket/place/distributed
         racket/class
         racket/place
         racket/runtime-path
         "fakeSTPworker.rkt")

(define-runtime-path fakeSTPworker-path "fakeSTPworker.rkt")


(provide main)

(define MAX-FAKE-LEVEL 25)
(define DIY-LEVEL 5)

(define (callit conn n)
  (fakeSTPworker-server-async-slow-double conn n))

(define (waitforit conn)
  (if (fakeSTPworker-server-ready? conn)
      (fakeSTPworker-server-get-last conn)
      (begin (sleep 0.1)
             (waitforit conn))))

(define (do-some-stuff conns n)
  (cond [(> n MAX-FAKE-LEVEL) empty]
        [(< n DIY-LEVEL) (cons (* n 2) (do-some-stuff conns (add1 n)))]
        [else (cons (begin (for ([c conns])
                             (callit c n))
                           (for/list ([c conns])
                             (waitforit c)))
                    (do-some-stuff conns (add1 n)))]))

(define (main)
  #|(define remote-node (spawn-remote-racket-node 
                        "landing" 
                        #:listen-port 6344))|#
  (define landing-node (spawn-remote-racket-node 
                        "landing" 
                        #:listen-port 6344))
  (define gracer-node (spawn-remote-racket-node 
                        "gracer" 
                        #:listen-port 6344))
  #|(define fakeSTPworker-place (supervise-place-at 
                               remote-node 
                               #:named 'fakeSTPworker-server 
                               fakeSTPworker-path 
                               'make-fakeSTPworker-server))|#
  (define fakeSTPworker-place (supervise-place-at 
                               landing-node 
                               #:named 'fakeSTPworker-server 
                               fakeSTPworker-path 
                               'make-fakeSTPworker-server))
  (define gracer-fstpw-place (supervise-place-at 
                               gracer-node 
                               #:named 'fakeSTPworker-server 
                               fakeSTPworker-path 
                               'make-fakeSTPworker-server))

  (define c (connect-to-named-place landing-node 
                                    'fakeSTPworker-server))
  (define d (connect-to-named-place gracer-node 
                                    'fakeSTPworker-server))
  (do-some-stuff (list c d) 0)

  #|
  (define bank-place  (supervise-place-at 
                        remote-node bank-path 
                        'make-bank))
  |#

  #|(message-router
    remote-node

    (after-seconds 2
      (define c (connect-to-named-place remote-node 
                                        'fakeSTPworker-server))
      (define d (connect-to-named-place remote-node 
                                        'fakeSTPworker-server))
      ;(tuple-server-hello c)
      ;(tuple-server-hello d)
      ;(displayln (fakeSTPworker-server-double c 3))
      ;(displayln (callit c 3))
      ;(displayln (fakeSTPworker-server-double d 4))
      ;(displayln (callit d 4))
      (displayln (do-some-stuff (list c d) 0))
      )

    (after-seconds 18
      (node-send-exit remote-node))
    (after-seconds 20
      (exit 0)))
  |#

  )


