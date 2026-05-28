(layout
	"Login"
	`(form (@ (action "/login") (method "post"))
		   (label (@ (for "uname")) (b "Username"))
		   (input (@ (type "text") (placeholder "Enter Username") (name "username") (required "")))
		   (label (@ (for "password")) (b "Password"))
		   (input (@ (type "password") (placeholder "Enter password") (name "password") (required "")))
		   (button (@ (type "submit")) "Login")
		   (label (input (@ (type "checkbox") (checked "checked") (name "remember"))) "Remember Me")))
