(require 'pg)
(require 'utils)

(defvar *db*)
(defvar *user* "youngnh")
(defvar *passwd* (read-passwd "Password: "))

(defvar *migrations* (make-hash-table))

(defun prod-db (dbname)
  (interactive "xDatabase: ")
  (setq *db* (format "%s_production" (replace-regexp-in-string
				       "-" "_" (symbol-name dbname)))))

(defun dev-db (dbname)
  (interactive "xDatabase: ")
  (setq *db* (format "%s_development" (replace-regexp-in-string
				       "-" "_" (symbol-name dbname)))))

(defmacro defstmt (name args &rest body)
  `(defun ,name ,args
     (with-pg-connection conn (*db* *user* *passwd*)
       (pg:exec conn (progn ,@body)))))

(defstmt create-table (name &rest columns)
  (format "create table %s ( %s );" name (join "," columns)))

(defstmt drop-table (name)
  (format "drop table %s;" name))

(defstmt add-column (tbl column-def)
  (format "alter table %s add column %s;" tbl column-def))

(defstmt remove-column (tbl column)
  (format "alter table %s drop column %s;" tbl column))

(defmacro deftable (name &rest columns)
  `(progn
     (fset (intern (format "%s-up" ',name))
	   (lambda ()
	     (create-table ,(format "%ss" name)
			   ,@(mapcar (lambda (col-def)
				       (concat
					(replace-regexp-in-string
					 "-" "_" (symbol-name (second col-def)))
					" " (third col-def)))
				     columns))))
     (fset (intern (format "%s-down" ',name))
	   (lambda ()
	     (drop-table ,(format "%ss" name))))))

(defmacro defcol (name on-sym tbl column-def)
  (let ((column-name (replace-regexp-in-string
		      "-" "_" (symbol-name (second column-def))))
	(column-type (third column-def)))
    `(progn
       (fset (intern (format "%s-up" ',name))
	     (lambda ()
	       (add-column ,(symbol-name tbl)
			   ,(format "%s %s" column-name column-type))))
       (fset (intern (format "%s-down" ',name))
	     (lambda ()
	       (remove-column ,(symbol-name tbl)
			    ,column-name))))))

(defmacro exec-in-current-db (stmt)
  `(with-pg-connection conn (*db* *user* *passwd*)
     (pg:exec conn ,stmt)))

(defun fixture (filename)
  (with-temp-buffer
    (insert-file-contents filename)
    (read (current-buffer))))

(defmacro select (sql)
  `(with-pg-connection conn (*db* *user* *passwd*)
     (pg:result (pg:exec conn ,sql) :tuples)))

(defmacro migration (version up down)
  (declare (indent 1))
  `(puthash ,version (list (lambda () (in-dir "migrations" ,@(cdr up)))
			   (lambda () (in-dir "migrations" ,@(cdr down))))
	    *migrations*))

(defun fixture (filename)
  (with-temp-buffer
    (insert-file-contents filename)
    (read (current-buffer))))

(defun db:migrate (&optional version)
  (interactive "P")
  ;; load migrations
  (if (zerop (hash-table-count *migrations*))
    (mapcar #'load-file (directory-files "migrations" t ".*el$")))
  ;; create schema_info table
  (unless (member "schema_info" (with-pg-connection conn (*db* *user* *passwd*)
				  (pg:tables conn)))
    (progn
      (exec-in-current-db "create table schema_info ( version int )")
      (exec-in-current-db "insert into schema_info values ( 0 )")))
  ;; execute migrations
  (let ((current-version (caar (select "select * from schema_info")))
	(version (if version version (hash-table-count *migrations*))))
    (if (< current-version version)
	(loop for i from (1+ current-version) to version
	      do (progn
		   (funcall (first (gethash i *migrations*)))
		   (exec-in-current-db (format "update schema_info set version='%d'" i))))
      (loop for i downfrom current-version to (1+ version)
	    do (progn
		 (funcall (second (gethash i *migrations*)))
		 (exec-in-current-db (format "update schema_info set version='%d'" (1- i))))))))

(provide 'db)