(require 'db)

(defun insert-nfl ()
  (progn
    ;; conferences
    (mapcar #'(lambda (conf)
		(with-pg-connection conn (*db* *user* *passwd*)
		  (pg:exec conn (format "insert into conferences (name) values ('%s');" conf))))
	    (fixture "conferences.elf"))

    ;; divisions
    (mapcar #'(lambda (conf)
		(let ((conf-id (caar (select (format "select conference_id from conferences where name='%s'" (car conf))))))
		  (mapcar #'(lambda (division)
			      (with-pg-connection conn (*db* *user* *passwd*)
				(pg:exec conn (format "insert into divisions (name, conference) values ('%s', %d)" division conf-id))))
			  (cadr conf))))
	    (fixture "divisions.elf"))

    ;; teams
    (mapcar #'(lambda (division)
		(let ((div-id (caar (select (format "select division_id from divisions where name='%s'" (car division))))))
		  (mapcar #'(lambda (team)
			      (with-pg-connection conn (*db* *user* *passwd*)
				(pg:exec conn (format "insert into teams (name, division) values ('%s', %d)" team div-id))))
			  (cadr division))))
	    (fixture "teams.elf"))))

(defun delete-nfl
  (with-pg-connection conn (*db* *user* *passwd*)
    (progn
      (pg:exec conn "delete * from teams;")
      (pg:exec conn "delete * from divisions;")
      (pg:exec conn "delete * from conferences;"))))

(migration 42
  (up (insert-nfl))
  (down (delete-nfl)))