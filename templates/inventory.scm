(layout
 "Inventory"
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
         (value "inventory")
         (formaction "/edit"))
      "Edit")

     (button
      (@ (class "button")
         (type "submit")
         (name "table")
         (value "inventory")
         (formaction "/delete"))
      "Delete")

     (button
      (@ (class "button")
         (type "submit")
         (name "table")
         (value "inventory")
         (formaction "/edit"))
      "Add")

     (button
      (@ (class "button")
         (type "submit")
         (name "table")
         (value "inventory")
         (formaction "/export"))
      "Export (.csv)"))

    (table
     (@ (id "table"))

     (tr
      (@ (class "header"))
      (th "Select")
      (th (@ (onclick "sortTable(1)")) "Name")
      (th (@ (onclick "sortTable(1)")) "Description")
      (th (@ (onclick "sortTable(1)")) "SKU")
      (th (@ (onclick "sortTable(1)")) "Price")
      (th (@ (onclick "sortTable(1)")) "Quantity")
      (th (@ (onclick "sortTable(1)")) "Created At"))

     ,@(map
        (lambda (row)
          `(tr
            (td
             (input
              (@ (type "checkbox")
                 (name "idx")
                 (value ,(alist-ref 'id row))))

            )
            (td ,(alist-ref 'name row))
            (td ,(alist-ref 'description row))
            (td ,(alist-ref 'sku row))
            (td ,(alist-ref 'price row))
            (td ,(alist-ref 'quantity row))
            (td ,(alist-ref 'created_at row))))
        table-data)))))
