(layout
 "Sales"

 `(section

   (input
    (@ (type "text")
       (id "search")
       (onkeyup "myFunction()")
       (placeholder "Search...")))

   (form
    (@ (method "POST"))

    (div
     (@ (class "actions"))

     (button
      (@ (class "button")
         (type "submit")
         (name "table")
         (value "sales")
         (formaction "/edit"))
      "Edit")

     (button
      (@ (class "button")
         (type "submit")
         (name "table")
         (value "sales")
         (formaction "/delete"))
      "Delete")

     (button
      (@ (class "button")
         (type "submit")
         (name "table")
         (value "sales")
         (formaction "/edit"))
      "Add")

     (button
      (@ (class "button")
         (type "submit")
         (name "table")
         (value "sales")
         (formaction "/export"))
      "Export (.csv)")))

   (table
    (@ (id "table"))

    (tr
     (@ (class "header"))

     (th "Select")
     (th "Inventory")
     (th "User")
     (th "Quantity")
     (th "Total Price")
     (th "Created At"))

    ,@(map

       (lambda (row)

         (let ((inventory-name
                (alist-ref 'inventory_name row))

               (username
                (alist-ref 'username row)))

           `(tr

             (td
              (input
               (@ (type "checkbox")
                  (name "idx")
                  (value ,(alist-ref 'id row)))))

             (td ,(if inventory-name
                      inventory-name
                      "Unknown"))

             (td ,(if username
                      username
                      "Unknown"))

             (td ,(alist-ref 'quantity row))
             (td ,(alist-ref 'total_price row))
             (td ,(alist-ref 'created_at row)))))

       table-data))))
