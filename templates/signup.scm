(layout
 "Sign Up"

 `(form
   (@ (action "/signup")
      (method "post"))

   (label (@ (for "username"))
          (b "Username"))

   (input
    (@ (type "text")
       (name "username")
       (placeholder "Choose Username")
       (required "")))

   (label (@ (for "password"))
          (b "Password"))

   (input
    (@ (type "password")
       (name "password")
       (placeholder "Choose Password")
       (required "")))

   (label (@ (for "role"))
          (b "Role"))

   (select
    (@ (name "role"))

    (option
     (@ (value "employee"))
     "Employee")

    (option
     (@ (value "manager"))
     "Manager")

    (option
     (@ (value "admin"))
     "Admin"))

   (button
    (@ (type "submit"))
    "Create Account")))
