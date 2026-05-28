(layout
	"Employees"
	`(section
	  (input (@ (type "text") (id "search") (onkeyup "myFunction()") (placeholder "Search...")))
	  (form (@ (method "POST"))
			(div (@ (class "actions"))
				 (button (@ (class "button") (type "submit") (name "table") (value "employee") (formaction "/edit")) "Edit")
				 (button (@ (class "button") (type "submit") (name "table") (value "employee") (formaction "/delete")) "Delete")
				 (button (@ (class "button") (type "submit") (name "table") (value "employee") (formaction "/edit")) "Add")
				 (button (@ (class "button") (type "submit") (name "table") (value "employee") (formaction "/export")) "Export (.csv)")
				 )
	  (table (@ (id "table"))
			 (tr (@ (class "header"))
				 (th "Select")
				 (th (@ (onclick "sortTable(1)")) "Full Name")
				 (th (@ (onclick "sortTable(1)")) "Phone Number")
				 (th (@ (onclick "sortTable(1)")) "Address")
				 (th (@ (onclick "sortTable(1)")) "Email")
				 (th (@ (onclick "sortTable(1)")) "Salary"))
			 ,@(map
				(lambda (row)
				  `(tr
					(td (input (@ (type "checkbox") (name "idx") (value ,(alist-ref 'id row)))))
					(td ,(alist-ref 'fullname row))
					(td ,(alist-ref 'tel row))
					(td ,(alist-ref 'address row))
					(td ,(alist-ref 'email row))
					(td ,(alist-ref 'salary row))))
				table-data)))))
