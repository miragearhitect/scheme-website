(layout
 "Edit"

 (cond

  ;; ======================================================
  ;; EMPLOYEE
  ;; ======================================================

  ((string=? table "employee")

   `(form
     (@ (method "POST")
        (action "/edit"))

     (input
      (@ (type "hidden")
         (name "table")
         (value ,table)))

     ,@(if idx
           `((input
              (@ (type "hidden")
                 (name "idx")
                 (value ,idx))))
           '())

     (label (@ (for "fullname")) "Full Name")

     (input
      (@ (type "text")
         (id "fullname")
         (name "fullname")
         (required "")
         (value ,(or (alist-ref 'fullname employee) ""))))

     (label (@ (for "tel")) "Phone Number")

     (input
      (@ (type "text")
         (id "tel")
         (name "tel")
         (required "")
         (value ,(or (alist-ref 'tel employee) ""))))

     (label (@ (for "address")) "Address")

     (input
      (@ (type "text")
         (id "address")
         (name "address")
         (required "")
         (value ,(or (alist-ref 'address employee) ""))))

     (label (@ (for "email")) "Email")

     (input
      (@ (type "email")
         (id "email")
         (name "email")
         (required "")
         (value ,(or (alist-ref 'email employee) ""))))

     (label (@ (for "salary")) "Salary")

     (input
      (@ (type "number")
         (id "salary")
         (name "salary")
         (required "")
         (value ,(or (alist-ref 'salary employee) ""))))

     (button
      (@ (type "submit"))
      ,(if idx
           "Edit Employee"
           "Create Employee"))))

  ;; ======================================================
  ;; INVENTORY
  ;; ======================================================

  ((string=? table "inventory")

   `(form
     (@ (method "POST")
        (action "/edit"))

     (input
      (@ (type "hidden")
         (name "table")
         (value ,table)))

     ,@(if idx
           `((input
              (@ (type "hidden")
                 (name "idx")
                 (value ,idx))))
           '())

     (label (@ (for "name")) "Name")

     (input
      (@ (type "text")
         (id "name")
         (name "name")
         (required "")
         (value ,(or (alist-ref 'name inventory) ""))))

     (label (@ (for "description")) "Description")

     (textarea
      (@ (id "description")
         (name "description"))
      ,(or (alist-ref 'description inventory) ""))

     (label (@ (for "sku")) "SKU")

     (input
      (@ (type "text")
         (id "sku")
         (name "sku")
         (required "")
         (value ,(or (alist-ref 'sku inventory) ""))))

     (label (@ (for "price")) "Price")

     (input
      (@ (type "number")
         (id "price")
         (name "price")
         (required "")
         (value ,(or (alist-ref 'price inventory) ""))))

     (label (@ (for "quantity")) "Quantity")

     (input
      (@ (type "number")
         (id "quantity")
         (name "quantity")
         (required "")
         (value ,(or (alist-ref 'quantity inventory) ""))))

     (button
      (@ (type "submit"))
      ,(if idx
           "Edit Inventory"
           "Create Inventory"))))

  ;; ======================================================
  ;; SALES
  ;; ======================================================

  ((string=? table "sales")

   `(form
     (@ (method "POST")
        (action "/edit"))

     (input
      (@ (type "hidden")
         (name "table")
         (value ,table)))

     ,@(if idx
           `((input
              (@ (type "hidden")
                 (name "idx")
                 (value ,idx))))
           '())

     (label (@ (for "inventory_id")) "Inventory ID")

     (input
      (@ (type "number")
         (id "inventory_id")
         (name "inventory_id")
         (required "")
         (value ,(or (alist-ref 'inventory_id sale) ""))))

     (label (@ (for "user_id")) "User ID")

     (input
      (@ (type "number")
         (id "user_id")
         (name "user_id")
         (required "")
         (value ,(or (alist-ref 'user_id sale) ""))))

     (label (@ (for "quantity")) "Quantity")

     (input
      (@ (type "number")
         (id "quantity")
         (name "quantity")
         (required "")
         (value ,(or (alist-ref 'quantity sale) ""))))

     (label (@ (for "total_price")) "Total Price")

     (input
      (@ (type "number")
         (id "total_price")
         (name "total_price")
         (required "")
         (value ,(or (alist-ref 'total_price sale) ""))))

     (button
      (@ (type "submit"))
      ,(if idx
           "Edit Sale"
           "Create Sale"))))

  ;; ======================================================
  ;; USERS
  ;; ======================================================

  ((string=? table "users")

   `(form
     (@ (method "POST")
        (action "/edit"))

     (input
      (@ (type "hidden")
         (name "table")
         (value ,table)))

     ,@(if idx
           `((input
              (@ (type "hidden")
                 (name "idx")
                 (value ,idx))))
           '())

     (label (@ (for "username")) "Username")

     (input
      (@ (type "text")
         (id "username")
         (name "username")
         (required "")
         (value ,(or (alist-ref 'username user) ""))))

     (label (@ (for "password_hash")) "Password Hash")

     (input
      (@ (type "text")
         (id "password_hash")
         (name "password_hash")
         (required "")
         (value ,(or (alist-ref 'password_hash user) ""))))

     (label (@ (for "role")) "Role")

     (input
      (@ (type "text")
         (id "role")
         (name "role")
         (required "")
         (value ,(or (alist-ref 'role user) ""))))

     (button
      (@ (type "submit"))
      ,(if idx
           "Edit User"
           "Create User"))))

  ;; ======================================================
  ;; FALLBACK
  ;; ======================================================

  (else

   `(section
     (h2 "Unknown table")
     (p "Invalid table type.")))))
