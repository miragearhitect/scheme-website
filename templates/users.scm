(layout
 "Users"

 `(section

   (input
    (@ (type "text")
       (id "search")
       (onkeyup "myFunction()")
       (placeholder "Search...")))

   (form
    (@ (method "POST"))

    ;; IMPORTANT
    (input
     (@ (type "hidden")
        (name "table")
        (value "users")))

    (div
     (@ (class "actions"))

     (button
      (@ (class "button")
         (type "submit")
         (formaction "/edit"))
      "Edit")

     (button
      (@ (class "button")
         (type "submit")
         (formaction "/delete"))
      "Delete")

     (button
      (@ (class "button")
         (type "submit")
         (formaction "/edit"))
      "Add")

     (button
      (@ (class "button")
         (type "submit")
         (formaction "/export"))
      "Export (.csv)"))

    (table
     (@ (id "table"))

     (tr
      (@ (class "header"))
      (th "Select")
      (th (@ (onclick "sortTable(1)")) "Username")
      (th (@ (onclick "sortTable(2)")) "Password Hash")
      (th (@ (onclick "sortTable(3)")) "Role")
      (th (@ (onclick "sortTable(4)")) "Created At"))

     ,@(map

        (lambda (row)

          `(tr

            (td
             (input
              (@ (type "checkbox")
                 (name "idx")
                 (value ,(alist-ref 'id row)))))

            (td
             ,(or (alist-ref 'username row) ""))

            (td
             ,(or (alist-ref 'password_hash row) ""))

            (td
             ,(or (alist-ref 'role row) ""))

            (td
             ,(or (alist-ref 'created_at row) ""))))

        table-data)))))
