#lang racket/base

(require racket/set
         racket/place/distributed
         racket/class
         racket/place
         racket/runtime-path
         "num-server.rkt"
         "place-worker.rkt")

(provide main
         gen-works
         merge-works)

#|

define number-of-places
define ranges for places

1. initiate remote places
2. have each place generate a bunch of random numbers and send the numbers to the appropriate place based on range
3. remote places merge multiple results, removing duplicates
4. collect results in final result

|#

(define DPT-PORT 6341)
(define MAX-NUM 100)
(define NUM-PLACES 4)
(define RANGES (cons 0 (for/list ([i NUM-PLACES])
                         (add1 (* (add1 i) (quotient MAX-NUM NUM-PLACES))))))

;(define-runtime-path bank-path "bank.rkt")
;(define-runtime-path tuple-path "tuple.rkt")
(define-runtime-path num-path "num-server.rkt")
(define-runtime-path plpath "place-worker.rkt")


(define (gen-works n)
  (let* ([all (sort (build-list n (lambda (_) (random MAX-NUM))) <)])
    (for/list ([i NUM-PLACES])
      (filter (lambda (n) (and (<= (list-ref RANGES i) n) (< n (list-ref RANGES (add1 i))))) all))))

;(gen-works 20)


;; merge-works: (listof (listof number))
;; lists of numbers in my range coming from other workers
(define (merge-works low)
  (let ([myset (list->mutable-set (car low))])
    (for* ([w (cdr low)]
           [n w])
      (set-add! myset n))
    (sort (set->list myset) <)))
#| test merge-works
(let ([several (build-list NUM-PLACES (lambda (_) (gen-works 100)))])
  (for ([low several]) (display low))
  (for/list ([i NUM-PLACES])
    (merge-works (map (lambda (low) (list-ref low i)) several))))
|#

#|
(define (main)
  (define remote-node (spawn-remote-racket-node
                       "gracer"
                       #:listen-port DPT-PORT))
  (define tuple-place (supervise-place-at
                       remote-node
                       #:named 'num-server
                       num-path
                       'make-num-server))
  #|(define back-place (supervise-place-at
                      remote-node bank-path 'make-bank))|#
  
  (message-router
   remote-node
   (after-seconds 2
                  (define n1 (connect-to-named-place remote-node
                                                     'num-server))
                  (num-server-hello n1)
                  (displayln (num-server-echo n1 3))
                  (displayln (num-server-echo n1 9))
                  (displayln (num-server-echo n1 5))
                  (displayln (num-server-echo n1 1))
                  (displayln (num-server-echo n1 2))
                  )
   (after-seconds 10
                  (node-send-exit remote-node))
   (after-seconds 12
                  (exit 0))))
  |#
#|
(define (main)
  (let ([pls (for/list ([i (in-range 2)])
              (dynamic-place "place-worker.rkt" 'place-main))])
   (for ([i (in-range 2)]
         [p pls])
      (place-channel-put p i)
      (printf "~a\n" (place-channel-get p)))
   (map place-wait pls)))|#

(define (main)
  ;(define gracer-node (spawn-remote-racket-node "gracer" #:listen-port DPT-PORT))
  ;(define gwplc (supervise-place-at gracer-node #:named 'place-worker plpath 'make-place-worker))

  (define landing-node (spawn-remote-racket-node "landing" #:listen-port DPT-PORT))
  (define lwplc (supervise-place-at landing-node #:named 'place-worker plpath 'make-place-worker))
  
  (message-router landing-node
                  (after-seconds 1
                                 ;(for ([
                                 (define cn (connect-to-named-place landing-node 'place-worker))
                                 ;(displayln (place-worker-hello cn))
                                 (displayln (place-worker-setid cn 3))
                                 (displayln (place-worker-echo cn 0))
                                 (displayln (place-worker-incr cn 0)))
                  (after-seconds 20
                                 (node-send-exit landing-node))
                  (after-seconds 22
                                 (exit 0))))