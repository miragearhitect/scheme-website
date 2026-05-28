#!/usr/bin/env csi

(import (chicken io)
		(chicken format)
		(chicken string)
		(chicken file)
		(chicken irregex))

(define templates-dir "templates/")


(define (last list)
  (cond ((null? list) '())
		((null? (cdr list)) (car list))
		(else (last (cdr list)))))

(define (basename path)
  (car (string-split (last (string-split path "/")) ".")))


(define (render-template template-file output-file)
  (let ((in-port  (open-input-file template-file))
        (out-port (open-output-file output-file)))
    (display (format "(define (template-~a) (string-append " (basename template-file)) out-port)

    (let loop ((ch (read-char in-port))
               (inside? #f)         
               (buf   ""))
      (cond
        ((eof-object? ch)
         (unless (string=? buf "")
           (display (format "\"~a\"" buf) out-port))
         (display "))" out-port)
         (close-input-port in-port)
         (close-output-port out-port))

        ((char=? ch #\%)
         (if inside?                     
             (begin
               (display buf out-port)
               (set! buf "")
               (loop (read-char in-port) #f ""))
             (begin
               (unless (string=? buf "")
                 (display (format "\"~a\"" buf) out-port))
               (set! buf "")
               (loop (read-char in-port) #t ""))))
        (else
         (loop (read-char in-port)
               inside?
               (string-append buf (string ch))))))))



(find-files templates-dir
			#:test #"\\.$"
			#:action (lambda (path _prev)
					   (display path)
					   (newline)
					   #t)
			)



(render-template "templates/test.tt" "test.scm")
(exit 0)
