(import (chicken base)
        (chicken io)
        (chicken eval)
        sxml-serializer)

(define (render-page filepath . maybe-bindings)
  (let* ((bindings (if (null? maybe-bindings)
                       '()
                       (car maybe-bindings)))
         (env (interaction-environment)))

	(load "templates/layout.scm")
	
    ;; inject bindings into env
    (for-each
      (lambda (binding)
        (eval `(define ,(car binding) ',(cdr binding))
              env))
      bindings)

    ;; read + eval template
    (serialize-sxml
      (eval
        (with-input-from-file filepath read)
        env)
      method: 'html)))

(print
  (render-page
    "templates/employees.scm"
    '((page-title . "Hello")
      (message . "this is a message"))))

(exit)
