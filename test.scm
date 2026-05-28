(define (template-test) (string-append "<section>
	<p>"(when #t (output "Hello, from Scheme Template!"))"</p>
</section>
"))