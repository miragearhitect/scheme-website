(module sqlite3 (sqlite3-open sqlite3-close)
		(import (chicken base)
				(chicken foreign)
				(chicken format)
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

		(define-external (sql_callback (c-pointer userptr) (int ncols) (c-string-list colvals) (c-string-list colnames)) int
		  (display (format "ncol = ~a\n" ncols))
		  (display (format "colvals = ~a\n" colvals))
		  (display (format "colnames = ~a\n" colnames)))
		  

		;; (define sqlite3-exec (foreign-safe-lambda* int (())))
		
		;; (define sqlite3-open (foreign-lambda (c-pointer (struct "sqlite3")) "sqlite3__open" c-string))
		;; (define sqlite3--exec (foreign-lambda int "sqlite3_exec" (c-pointer (struct "sqlite3") ())))

		;; (define sqlite3-exec (foreign-safe-lambda* int ((c-string str))
												   ;; ))
		
		;; C signature: int cb(void* userptr, int ncols, char** colvals, char** colnames)
		;; (define-external (sql-callback ncols colvals colnames) int)
		;; (define (sqlite3-exec db sql f)
		  ;; (define-external (callback  (int ncols) (string colvals) (string colnames)) int
			;; 0)
		  ;; )

;; int sqlite3_exec(
  ;; sqlite3*,                                  /* An open database */
  ;; const char *sql,                           /* SQL to be evaluated */
  ;; int (*callback)(void*,int,char**,char**),  /* Callback function */
  ;; void *,                                    /* 1st argument to callback */
  ;; char **errmsg                              /* Error msg written here */
;; );
		
		)

(import sqlite3)

(let ((db (sqlite3-open "test.db")))
  (display "Opened!\n")
  (sqlite3-exec db "INSERT (name) as 'hi' INTO TABLE") ;; Returns list of entries (name age ...)
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
