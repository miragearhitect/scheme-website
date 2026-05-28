(define (layout title body)
  `(html
	(head
	 (link (@ (rel "icon") (href "/favicon.ico") (type "image/x-icon")))
	 (link (@ (rel "icon") (href "/favicon.png") (type "image/png")))
	 (link (@ (rel "icon") (href "/favicon.gif") (type "image/gif")))
	 (link (@ (rel "stylesheet") (href "/style.css")))
	 (title ,title))
	(body
	 (header
	  (h1 ,title)
	  (div (@ (class "button-group"))
		   (a (@ (class "button") (href "/")) "Dashboard")
		   (a (@ (class "button") (href "/Employees")) "Employees")
		   (a (@ (class "button") (href "/Inventory")) "Inventory")
		   (a (@ (class "button") (href "/Sales")) "Sales")
		   (a (@ (class "button") (href "/Users")) "Users"))
	  (div (@ (class "button-group"))
		   (a (@ (class "button") (href "/login")) "Login")
		   (a (@ (class "button") (href "/signup")) "SignUp")))
	 (main
	  ,body)
	 (footer
	  (p "Page footer."))
	 (script (@ (src "/script.js")) ""))))
