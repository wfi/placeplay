#lang racket/base

(define a-string "this is a string")


(time (sleep 1))

#|
(define (access-fs)
  (unless (hash? a-string)
    (set! a-string "this is still a string")
    (cond [(file-exists? "tmp/foo.txt")
           (with-input-from-file "tmp/foo.txt" read)]
          [else
           (sleep 3)
           null]))
  )
|#

;#|
(define (access-fs)
  (with-output-to-file "superf.log"
    (lambda ()
      (printf "Starting call to access-fs with current-directory as ~a and current-directory-for-user as ~a~%"
              (current-directory) (current-directory-for-user))
      (unless (hash? a-string)
        (set! a-string "this is still a string")
        (cond [(file-exists? "tmp/foo.txt")
               (with-input-from-file "tmp/foo.txt" read)]
              [else
               ;(error 'access-fs "could not find foo.txt in tmp folder")
               null]))
      (printf "done with this call to access-fs~%"))
    #:exists 'append))
;|#

(time (access-fs))