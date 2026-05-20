(module sqlite3 (sqlite3-open sqlite3-close sqlite3-exec)
		(import (chicken base)
				(chicken foreign)
				(chicken format)
				(chicken memory)
				(chicken plist)
				scheme)

		#>
		#include <sqlite3.h>
		extern sqlite3* sqlite3__open(const char *filepath);
		<#

		(define sqlite3-open (foreign-lambda* c-pointer ((c-string filename))
											  "sqlite3 *db = NULL;
                                               int res = sqlite3_open(filename, &db);
                                               if (res != SQLITE_OK) C_return(NULL);
                                               C_return(db);"))
		
		(define sqlite3-close (foreign-lambda void "sqlite3_close" (c-pointer (struct "sqlite3"))))
		(define sqlite3-errmsg (foreign-lambda c-string "sqlite3_errmsg" (c-pointer (struct "sqlite3"))))
		
		(define (sqlite3-exec db sql)
		  (define char-vector-ref (foreign-lambda* c-string (((c-pointer c-string) str) (int index))
												   "char *s = (str[index]);
                                                    C_return(s);"))


		  
		  (define-external (sql_callback (c-pointer userptr) (int ncols) ((c-pointer c-string) colvals) ((c-pointer c-string) colnames)) int
			(let ((rows (pointer->object userptr)))
			(do ((i 0 (+ i 1)))
				((= i ncols))
			  (set! rows
			   (cons
				(cons
				 (string->symbol
				  (char-vector-ref colnames i))
				 (char-vector-ref colvals i))
				rows))))
			0)
		  
		  
		  (define sqlite3--exec (foreign-safe-lambda* int ((c-pointer db) (c-string sql) (c-pointer arg1))
													  "char *errmsg = NULL;
                                                       int res = sqlite3_exec(db, sql, sql_callback, arg1, &errmsg);
                                                       C_return(res);"))

		  (define rows  '())
		  (when (not (= (sqlite3--exec db sql (object->pointer rows)) (foreign-value "SQLITE_OK" int)))
			 (error (format "sqlite3: ~a\n" (sqlite3-errmsg db))))))

(import sqlite3
		(chicken format))

(let ((db (sqlite3-open "test.db")))
  (display "Opened!\n")
  (printf "exec: ~a\n" (sqlite3-exec db "CREATE TABLE IF NOT EXISTS Person (ID PRIMARY KEY, NAME TEXT, AGE INTEGER)"))
  ;; (printf "exec: ~a\n" (sqlite3-exec db "INSERT INTO Person (id, name, age) VALUES (0, 'Bob', 45)"))
  (printf "exec: ~a\n" (sqlite3-exec db "SELECT * FROM Person"))
  (sqlite3-close db))

;; (module sqlite3 (open)
		;; (import (chicken foreign))
		;; #>
		;; #include <sqlite3.h>
		;; <#

		;; (define-foreign-type sqlite3 c-pointer)
		
		;; int sqlite3_open(
		;; const char *filename,   /* Database filename (UTF-8) */
		;; sqlite3 **ppDb          /* OUT: SQLite db handle */
		;; );
		
		;; (define open
		  ;; (foreign-lambda int "sqlite3_open" c-string sqlite3))
		
		
		;; )



;; (display "sqlite = " (sqlite3-open "site.db" nil)

;; (let ((db (make-pointer c-pointer)))
  ;; (pointer-set db 0 (cast #f c-pointer))
		   ;; ))
