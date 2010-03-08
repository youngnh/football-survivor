(require 'db)

(defun insert-user (username email)
  (exec-in-current-db (format "insert into users (username, email) values ('%s', '%s')" username email)))

(migration 7
  (up (let ((users (fixture "users.elf")))
	(mapcar #'(lambda (user-info)
		    (apply #'insert-user user-info)) users)))
  (down (exec-in-current-db "delete from users;")))