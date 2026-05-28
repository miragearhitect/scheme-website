(import (chicken base)
        (chicken io)
        (chicken tcp)
        (chicken format)
        (chicken string)
        (chicken eval)
        srfi-1
        srfi-13
        uri-common
        sxml-serializer
        sqlite3)

(define db #f)

;; =========================================================
;; AUTH
;; =========================================================

(define (hash-password password)

  ;; demo only

  (number->string
   (string-hash password)))

(define (find-user username)

  (let ((rows

         (map-row

          (lambda (id username password-hash role created-at)

            `((id . ,id)
              (username . ,username)
              (password_hash . ,password-hash)
              (role . ,role)
              (created_at . ,created-at)))

          db

          "
SELECT id,
       username,
       password_hash,
       role,
       created_at

FROM users

WHERE username = ?
"

          username)))

    (if (null? rows)
        #f
        (car rows))))

;; =========================================================
;; UTIL
;; =========================================================

(define (render-page filepath . maybe-bindings)

  (let* ((bindings (if (null? maybe-bindings)
                       '()
                       (car maybe-bindings)))

         (env (interaction-environment)))

    (load "templates/layout.scm")

    (for-each
     (lambda (binding)

       (eval
        `(define ,(car binding)
           ',(cdr binding))
        env))

     bindings)

    (serialize-sxml

     (eval
      (with-input-from-file filepath read)
      env)

     method: 'html)))

(define (http/read-headers in)

  (let loop ((headers '()))

    (let ((line
           (string-trim-right
            (read-line in))))

      (if (string=? line "")

          (reverse headers)

          (let* ((parts (string-split line ":"))

                 (key
                  (car parts))

                 (value
                  (string-trim-both
                   (string-intersperse
                    (cdr parts)
                    ":"))))

            (loop
             (cons
              (cons key value)
              headers)))))))

(define (http/header-ref headers key)
  (alist-ref key headers string=?))

(define (http/parse-form-urlencoded body)

  (map
   (lambda (pair)

     (let ((parts
            (string-split pair "=")))

       (cons
        (car parts)

        (if (> (length parts) 1)
            (cadr parts)
            ""))))

   (string-split body "&")))

(define (http/parse-request request)

  (let* ((line
          (string-trim-both request))

         (parts
          (string-split line " "))

         (verb
          (car parts))

         (path
          (cadr parts)))

    (list verb path)))

(define (http/respond out content . args)

  (let* ((status
          (if (null? args)
              "200 OK"
              (car args)))

         (headers
          (if (or (null? args)
                  (null? (cdr args)))
              '()
              (cadr args))))

    (format out "HTTP/1.1 ~a\r\n" status)
    (format out "Content-Type: text/html; charset=utf-8\r\n")
    (format out "Connection: close\r\n")

    (for-each
     (lambda (header)

       (format out
               "~a: ~a\r\n"
               (car header)
               (cdr header)))

     headers)

    (format out "\r\n")
    (format out "~a" content)

    (flush-output out)))

(define (form-value key form-data)

  (let ((value
         (alist-ref key form-data string=?)))

    (if value

        (uri-decode-string
         (string-translate value "+" " "))

        "")))

(define (form-values key form-data)

  (let loop ((lst form-data)
             (out '()))

    (cond

     ((null? lst)
      (reverse out))

     ((string=? (caar lst) key)

      (loop (cdr lst)
            (cons (cdar lst) out)))

     (else
      (loop (cdr lst)
            out)))))

(define (page? request verb path)

  (and
   (string=? (string-trim-both (list-ref request 0))
             verb)

   (string=? (string-trim-both (list-ref request 1))
             path)))

;; =========================================================
;; TABLE HELPERS
;; =========================================================

(define (table->path table)

  (cond

   ((string=? table "employee")
    "/Employees")

   ((string=? table "inventory")
    "/Inventory")

   ((string=? table "sales")
    "/Sales")

   ((string=? table "users")
    "/Users")

   (else "/")))

(define (table->sql-name table)

  (cond

   ((string=? table "employee")
    "employees")

   ((string=? table "inventory")
    "inventory")

   ((string=? table "sales")
    "sales")

   ((string=? table "users")
    "users")

   (else #f)))

;; =========================================================
;; EMPLOYEES
;; =========================================================

(define (employees->alist)

  (map-row

   (lambda (id fullname tel address email salary)

     `((id . ,id)
       (fullname . ,fullname)
       (tel . ,tel)
       (address . ,address)
       (email . ,email)
       (salary . ,salary)))

   db

   "
SELECT id,
       fullname,
       tel,
       address,
       email,
       salary

FROM employees

ORDER BY id DESC
"))

;; =========================================================
;; INVENTORY
;; =========================================================

(define (inventory->alist)

  (map-row

   (lambda (id name description sku price quantity created-at)

     `((id . ,id)
       (name . ,name)
       (description . ,description)
       (sku . ,sku)
       (price . ,price)
       (quantity . ,quantity)
       (created_at . ,created-at)))

   db

   "
SELECT id,
       name,
       description,
       sku,
       price,
       quantity,
       created_at

FROM inventory

ORDER BY id DESC
"))

;; =========================================================
;; SALES
;; =========================================================

(define (sales->alist)

  (map-row

   (lambda (id
            inventory-id
            inventory-name
            user-id
            username
            quantity
            total-price
            created-at)

     `((id . ,id)

       (inventory_id . ,inventory-id)
       (user_id . ,user-id)

       (inventory_name . ,inventory-name)
       (username . ,username)

       (quantity . ,quantity)
       (total_price . ,total-price)
       (created_at . ,created-at)))

   db

   "
SELECT
    sales.id,
    sales.inventory_id,
    inventory.name,
    sales.user_id,
    users.username,
    sales.quantity,
    sales.total_price,
    sales.created_at

FROM sales

LEFT JOIN inventory
       ON inventory.id = sales.inventory_id

LEFT JOIN users
       ON users.id = sales.user_id

ORDER BY sales.id DESC
"))

;; =========================================================
;; USERS
;; =========================================================

(define (users->alist)

  (map-row

   (lambda (id username password-hash role created-at)

     `((id . ,id)
       (username . ,username)
       (password_hash . ,password-hash)
       (role . ,role)
       (created_at . ,created-at)))

   db

   "
SELECT id,
       username,
       password_hash,
       role,
       created_at

FROM users

ORDER BY id DESC
"))

;; =========================================================
;; CSV
;; =========================================================

(define (csv-escape value)

  (let ((s
         (if value
             (->string value)
             "")))

    (string-append
     "\""
     (string-translate s "\"" "\"\"")
     "\"")))

(define (rows->csv rows)

  (string-intersperse

   (map

    (lambda (row)

      (string-intersperse
       (map csv-escape row)
       ","))

    rows)

   "\n"))

(define (table->csv-header table)

  (cond

   ((string=? table "employee")
    "id,fullname,tel,address,email,salary\n")

   ((string=? table "inventory")
    "id,name,description,sku,price,quantity,created_at\n")

   ((string=? table "sales")
    "id,inventory_id,user_id,quantity,total_price,created_at\n")

   ((string=? table "users")
    "id,username,password_hash,role,created_at\n")

   (else "")))

(define (table->rows table)

  (cond

   ((string=? table "employee")

    (map-row
     (lambda (id fullname tel address email salary)
       (list id fullname tel address email salary))
     db
     "SELECT id, fullname, tel, address, email, salary
      FROM employees"))

   ((string=? table "inventory")

    (map-row
     (lambda (id name description sku price quantity created-at)
       (list id name description sku price quantity created-at))
     db
     "SELECT id, name, description, sku, price, quantity, created_at
      FROM inventory"))

   ((string=? table "sales")

    (map-row
     (lambda (id inventory-id user-id quantity total-price created-at)
       (list id inventory-id user-id quantity total-price created-at))
     db
     "SELECT id, inventory_id, user_id, quantity, total_price, created_at
      FROM sales"))

   ((string=? table "users")

    (map-row
     (lambda (id username password-hash role created-at)
       (list id username password-hash role created-at))
     db
     "SELECT id, username, password_hash, role, created_at
      FROM users"))

   (else '())))

;; =========================================================
;; HANDLE CONNECTION
;; =========================================================

(define (handle-conn in out)

  (let* ((request
          (http/parse-request
           (read-line in)))

         (headers
          (http/read-headers in))

         (content-length
          (or
           (string->number
            (or (http/header-ref headers "Content-Length")
                "0"))
           0))

         (body
          (if (> content-length 0)
              (read-string content-length in)
              "")))

    (print request)

    (cond

     ;; =====================================================
     ;; DASHBOARD
     ;; =====================================================

     ((page? request "GET" "/")

      (http/respond
       out
       (render-page
        "templates/index.scm"
        '((title "Dashboard")))))

     ;; =====================================================
     ;; EMPLOYEES
     ;; =====================================================

     ((page? request "GET" "/Employees")

      (http/respond
       out
       (render-page
        "templates/employees.scm"
        `((title . "Employees")
          (table-data . ,(employees->alist))))))

     ;; =====================================================
     ;; INVENTORY
     ;; =====================================================

     ((page? request "GET" "/Inventory")

      (http/respond
       out
       (render-page
        "templates/inventory.scm"
        `((title . "Inventory")
          (table-data . ,(inventory->alist))))))

     ;; =====================================================
     ;; SALES
     ;; =====================================================

     ((page? request "GET" "/Sales")

      (http/respond
       out
       (render-page
        "templates/sales.scm"
        `((title . "Sales")
          (table-data . ,(sales->alist))))))

     ;; =====================================================
     ;; USERS
     ;; =====================================================

     ((page? request "GET" "/Users")

      (http/respond
       out
       (render-page
        "templates/users.scm"
        `((title . "Users")
          (table-data . ,(users->alist))))))

     ;; =====================================================
     ;; EDIT
     ;; =====================================================
;; =====================================================
;; EDIT
;; =====================================================

((page? request "POST" "/edit")

 (let* ((form-data
         (http/parse-form-urlencoded body))

        (table
         (form-value "table"
                     form-data))

        (idx
         (form-value "idx"
                     form-data)))

   ;; ===================================================
   ;; SAVE EMPLOYEE
   ;; ===================================================

   (when (and (string=? table "employee")
              (not (string=? (form-value "fullname" form-data) "")))

     (if (string=? idx "")

         (execute
          db
          "
INSERT INTO employees
(fullname, tel, address, email, salary)
VALUES (?, ?, ?, ?, ?)
"
          (form-value "fullname" form-data)
          (form-value "tel" form-data)
          (form-value "address" form-data)
          (form-value "email" form-data)
          (form-value "salary" form-data))

         (execute
          db
          "
UPDATE employees
SET fullname=?,
    tel=?,
    address=?,
    email=?,
    salary=?
WHERE id=?
"
          (form-value "fullname" form-data)
          (form-value "tel" form-data)
          (form-value "address" form-data)
          (form-value "email" form-data)
          (form-value "salary" form-data)
          idx)))

   ;; ===================================================
   ;; SAVE INVENTORY
   ;; ===================================================

   (when (and (string=? table "inventory")
              (not (string=? (form-value "name" form-data) "")))

     (if (string=? idx "")

         (execute
          db
          "
INSERT INTO inventory
(name, description, sku, price, quantity)
VALUES (?, ?, ?, ?, ?)
"
          (form-value "name" form-data)
          (form-value "description" form-data)
          (form-value "sku" form-data)
          (form-value "price" form-data)
          (form-value "quantity" form-data))

         (execute
          db
          "
UPDATE inventory
SET name=?,
    description=?,
    sku=?,
    price=?,
    quantity=?
WHERE id=?
"
          (form-value "name" form-data)
          (form-value "description" form-data)
          (form-value "sku" form-data)
          (form-value "price" form-data)
          (form-value "quantity" form-data)
          idx)))

   ;; ===================================================
   ;; SAVE SALES
   ;; ===================================================

   (when (and (string=? table "sales")
              (not (string=? (form-value "inventory_id" form-data) "")))

     (if (string=? idx "")

         (execute
          db
          "
INSERT INTO sales
(inventory_id, user_id, quantity, total_price)
VALUES (?, ?, ?, ?)
"
          (form-value "inventory_id" form-data)
          (form-value "user_id" form-data)
          (form-value "quantity" form-data)
          (form-value "total_price" form-data))

         (execute
          db
          "
UPDATE sales
SET inventory_id=?,
    user_id=?,
    quantity=?,
    total_price=?
WHERE id=?
"
          (form-value "inventory_id" form-data)
          (form-value "user_id" form-data)
          (form-value "quantity" form-data)
          (form-value "total_price" form-data)
          idx)))

   ;; ===================================================
   ;; SAVE USERS
   ;; ===================================================

   (when (and (string=? table "users")
              (not (string=? (form-value "username" form-data) "")))

     (if (string=? idx "")

         (execute
          db
          "
INSERT INTO users
(username, password_hash, role)
VALUES (?, ?, ?)
"
          (form-value "username" form-data)
          (form-value "password_hash" form-data)
          (form-value "role" form-data))

         (execute
          db
          "
UPDATE users
SET username=?,
    password_hash=?,
    role=?
WHERE id=?
"
          (form-value "username" form-data)
          (form-value "password_hash" form-data)
          (form-value "role" form-data)
          idx)))

   ;; ===================================================
   ;; LOAD ROWS FOR EDIT FORM
   ;; ===================================================

   (let ((employee '())
         (inventory '())
         (sale '())
         (user '()))

     (when (and (string=? table "employee")
                (not (string=? idx "")))

       (set! employee

         (car

          (map-row
           (lambda (id fullname tel address email salary)

             `((id . ,id)
               (fullname . ,fullname)
               (tel . ,tel)
               (address . ,address)
               (email . ,email)
               (salary . ,salary)))

           db

           "
SELECT id, fullname, tel, address, email, salary
FROM employees
WHERE id = ?
"
           idx))))

     (when (and (string=? table "inventory")
                (not (string=? idx "")))

       (set! inventory

         (car

          (map-row
           (lambda (id name description sku price quantity created-at)

             `((id . ,id)
               (name . ,name)
               (description . ,description)
               (sku . ,sku)
               (price . ,price)
               (quantity . ,quantity)
               (created_at . ,created-at)))

           db

           "
SELECT id, name, description, sku, price, quantity, created_at
FROM inventory
WHERE id = ?
"
           idx))))

     (when (and (string=? table "sales")
                (not (string=? idx "")))

       (set! sale

         (car

          (map-row
           (lambda (id inventory-id user-id quantity total-price created-at)

             `((id . ,id)
               (inventory_id . ,inventory-id)
               (user_id . ,user-id)
               (quantity . ,quantity)
               (total_price . ,total-price)
               (created_at . ,created-at)))

           db

           "
SELECT id, inventory_id, user_id, quantity, total_price, created_at
FROM sales
WHERE id = ?
"
           idx))))

     (when (and (string=? table "users")
                (not (string=? idx "")))

       (set! user

         (car

          (map-row
           (lambda (id username password-hash role created-at)

             `((id . ,id)
               (username . ,username)
               (password_hash . ,password-hash)
               (role . ,role)
               (created_at . ,created-at)))

           db

           "
SELECT id, username, password_hash, role, created_at
FROM users
WHERE id = ?
"
           idx))))

     (http/respond
      out
      (render-page
       "templates/edit.scm"

       `((table . ,table)
         (idx . ,idx)
         (employee . ,employee)
         (inventory . ,inventory)
         (sale . ,sale)
         (user . ,user)))))))
	 
     ;; =====================================================
     ;; DELETE
     ;; =====================================================

     ((page? request "POST" "/delete")

      (let* ((form-data
              (http/parse-form-urlencoded body))

             (table
              (form-value "table"
                          form-data))

             (ids
              (form-values "idx"
                           form-data))

             (sql-table
              (table->sql-name table)))

        (when sql-table

          (for-each

           (lambda (id)

             (when (not (string=? id ""))

               (execute
                db
                (string-append
                 "DELETE FROM "
                 sql-table
                 " WHERE id = ?")
                id)))

           ids))

        (http/respond
         out
         ""
         "303 See Other"
         `(("Location"
            . ,(table->path table))))))

     ;; =====================================================
     ;; EXPORT
     ;; =====================================================

     ((page? request "POST" "/export")

      (let* ((form-data
              (http/parse-form-urlencoded body))

             (table
              (form-value "table"
                          form-data))

             (rows
              (table->rows table))

             (csv
              (string-append
               (table->csv-header table)
               (rows->csv rows))))

        (format out "HTTP/1.1 200 OK\r\n")
        (format out "Content-Type: text/csv\r\n")
        (format out
                "Content-Disposition: attachment; filename=\"export.csv\"\r\n")
        (format out "\r\n")
        (format out "~a" csv)

        (flush-output out)))

     ;; =====================================================
     ;; LOGIN
     ;; =====================================================

     ((page? request "GET" "/login")

      (http/respond
       out
       (render-page
        "templates/login.scm"
        '((title "Login")))))

     ((page? request "POST" "/login")

      (let* ((form-data
              (http/parse-form-urlencoded body))

             (username
              (form-value "username"
                          form-data))

             (password
              (form-value "password"
                          form-data))

             (user
              (find-user username)))

        (if (and user
                 (string=?
                  (alist-ref 'password_hash user)
                  (hash-password password)))

            (http/respond
             out
             (render-page
              "templates/success.scm"

              `((title . "Login Success")
                (message .
                         ,(string-append
                           "Welcome "
                           username
                           "!")))))

            (http/respond
             out
             (render-page
              "templates/error.scm"

              '((title . "Login Failed")
                (message .
                         "Invalid username or password")))))))

     ;; =====================================================
     ;; SIGNUP
     ;; =====================================================

     ((page? request "GET" "/signup")

      (http/respond
       out
       (render-page
        "templates/signup.scm"
        '((title "SignUp")))))

     ((page? request "POST" "/signup")

      (let* ((form-data
              (http/parse-form-urlencoded body))

             (username
              (form-value "username"
                          form-data))

             (password
              (form-value "password"
                          form-data))

             (role
              (form-value "role"
                          form-data))

             (existing-user
              (find-user username)))

        (if existing-user

            (http/respond
             out
             (render-page
              "templates/error.scm"

              '((title . "Signup Failed")
                (message .
                         "Username already exists"))))

            (begin

              (execute
               db

               "
INSERT INTO users
(username, password_hash, role)
VALUES (?, ?, ?)
"

               username
               (hash-password password)

               (if (string=? role "")
                   "employee"
                   role))

              (http/respond
               out
               (render-page
                "templates/success.scm"

                `((title . "Signup Success")
                  (message .
                           ,(string-append
                             "Account created for "
                             username
                             "!")))))))))

     ;; =====================================================
     ;; STATIC
     ;; =====================================================

     ((page? request "GET" "/style.css")

      (http/respond
       out
       (with-input-from-file
           "static/style.css"
         read-string)))

     ((page? request "GET" "/script.js")

      (http/respond
       out
       (with-input-from-file
           "static/script.js"
         read-string)))

     ;; =====================================================
     ;; 404
     ;; =====================================================

     (else

      (http/respond
       out
       (render-page
        "templates/error.scm"

        '((title "404 not found")
          (message "This page does not exist")))

       "404 Not Found")))

    (flush-output out)

    (close-input-port in)
    (close-output-port out)))

;; =========================================================
;; SERVER
;; =========================================================

(define (serve host port)

  (let ((listener
         (tcp-listen port)))

    (printf
     "Serving HTTP on ~a port ~a (http://~a:~a/) ...\n"
     host
     port
     host
     port)

    (let loop ()

      (let-values (((in out)
                    (tcp-accept listener)))

        (let-values (((remote-host remote-port)
                      (tcp-addresses in)))

          (printf
           "Connection from ~a\n"
           remote-host))

        (handle-conn in out)

        (loop)))))

;; =========================================================
;; DATABASE
;; =========================================================

(define (init-db)

  (set! db
        (open-database "app.db"))

  (execute
   db
   "
CREATE TABLE IF NOT EXISTS employees (
    id       INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname TEXT NOT NULL,
    tel      TEXT NOT NULL,
    address  TEXT NOT NULL,
    email    TEXT NOT NULL,
    salary   INTEGER NOT NULL
);
")

  (execute
   db
   "
CREATE TABLE IF NOT EXISTS inventory (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name         TEXT    NOT NULL,
    description  TEXT,
    sku          TEXT    UNIQUE,
    price        INTEGER NOT NULL,
    quantity     INTEGER NOT NULL DEFAULT 0,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP
);
")

  (execute
   db
   "
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username      TEXT    NOT NULL UNIQUE,
    password_hash TEXT    NOT NULL,
    role          TEXT    NOT NULL DEFAULT 'employee',
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);
")

  (execute
   db
   "
CREATE TABLE IF NOT EXISTS sales (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    inventory_id  INTEGER NOT NULL,
    user_id       INTEGER,
    quantity      INTEGER NOT NULL,
    total_price   INTEGER NOT NULL,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (inventory_id)
        REFERENCES inventory(id),

    FOREIGN KEY (user_id)
        REFERENCES users(id)
);
"))

(init-db)

(serve "127.0.0.1" 8086)

(close-database db)
