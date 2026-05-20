(import (chicken io)
        (chicken tcp)
        (chicken format)
		(chicken string))


(define (parse-request request)
  (let* ((parts (string-split request))
		 (verb (list-ref parts 0))
		 (path (list-ref parts 1)))
	(list verb path)))


(define (http/respond out content . maybe-status)
  (let ((status (if (null? maybe-status) "200 OK" (car maybe-status))))
	(format out "HTTP/1.1 ~a\r\n" status)
	(format out "Content-Type: text/html; charset=utf-8\r\n")
	(format out "Connection: close\r\n")
	(format out "\r\n")
	(format out "~a" content)
	(format out "\r\n")

	(flush-output out)))

(define (handle-conn in out)
  (let* ((request (read-line in))
		 (verb (list-ref (parse-request request) 0))
		 (path (list-ref (parse-request request) 1)))
	(print request)
	(printf "Verb: ~a Path: ~a\n" verb path)

	(cond ((and (string=? verb "GET") (string=? path "/")) (http/respond out "<h1>Index</h1>"))
		  (else (http/respond out "<h1>404 Not Found</h1>" "404 Not Found")))

	(flush-output out)
	(close-input-port in)
	(close-output-port out)))

(define (serve port)
  (let ((listener (tcp-listen port)))
    (printf "Listening on port ~a\n" port)

    (let loop ()
      (let-values (((in out) (tcp-accept listener)))
		(let-values (((remote-host remote-port)
					  (tcp-addresses in)))
		  (printf "Connection from ~a\n" remote-host))
        (handle-conn in out)
        (loop)))))

(serve 8086)
