(layout
 "Dashboard"

 `(section

   (div
    (@ (class "stats-grid"))

    ;; =========================================
    ;; EMPLOYEES
    ;; =========================================

    (div
     (@ (class "stat-card"))

     (h2 "Employees")

     (p
      (@ (class "stat-number"))
      ,(number->string
        (length (employees->alist))))

     (a
      (@ (class "button")
         (href "/Employees"))
      "View Employees"))

    ;; =========================================
    ;; INVENTORY
    ;; =========================================

    (div
     (@ (class "stat-card"))

     (h2 "Inventory Items")

     (p
      (@ (class "stat-number"))
      ,(number->string
        (length (inventory->alist))))

     (a
      (@ (class "button")
         (href "/Inventory"))
      "View Inventory"))

    ;; =========================================
    ;; SALES
    ;; =========================================

    (div
     (@ (class "stat-card"))

     (h2 "Sales")

     (p
      (@ (class "stat-number"))
      ,(number->string
        (length (sales->alist))))

     (a
      (@ (class "button")
         (href "/Sales"))
      "View Sales"))

    ;; =========================================
    ;; USERS
    ;; =========================================

    (div
     (@ (class "stat-card"))

     (h2 "Users")

     (p
      (@ (class "stat-number"))
      ,(number->string
        (length (users->alist))))

     (a
      (@ (class "button")
         (href "/Users"))
      "View Users")))

   ;; =========================================
   ;; RECENT EMPLOYEES
   ;; =========================================

   (section

    (h2 "Recent Employees")

    (table

     (tr
      (@ (class "header"))

      (th "Full Name")
      (th "Email")
      (th "Salary"))

     ,@(map

        (lambda (row)

          `(tr

            (td
             ,(alist-ref 'fullname row))

            (td
             ,(alist-ref 'email row))

            (td
             ,(number->string
               (or (alist-ref 'salary row) 0)))))

        (take (employees->alist) 5))))

   ;; =========================================
   ;; RECENT SALES
   ;; =========================================

   (section

    (h2 "Recent Sales")

    (table

     (tr
      (@ (class "header"))

      (th "Inventory")
      (th "User")
      (th "Quantity")
      (th "Total Price"))

     ,@(map

        (lambda (row)

          `(tr

            (td
             ,(or (alist-ref 'inventory_name row)
                  ""))

            (td
             ,(or (alist-ref 'username row)
                  ""))

            (td
             ,(number->string
               (or (alist-ref 'quantity row) 0)))

            (td
             ,(number->string
               (or (alist-ref 'total_price row) 0)))))

        (take (sales->alist) 5))))))
