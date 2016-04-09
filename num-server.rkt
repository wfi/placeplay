#lang racket/base

(require racket/match
         racket/place/define-remote-server)

(define-named-remote-server num-server
  (define-rpc (echo n)
    n)
  (define-cast (hello)
    (printf "hello from define-cast\n")
    (flush-output)))
