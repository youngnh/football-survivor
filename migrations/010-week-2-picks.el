(require 'db)

(defun insert-pick-for-week (week username pick email-id)
  (exec-in-current-db (format "insert into picks (username, pick, week, email_id) values ('%s', '%s', %d, '%s')" username pick week email-id)))

(migration 10
  (up (let ((picks (fixture "week-2-picks.elf")))
	(mapcar #'(lambda (plr-pick)
		    (apply #'insert-pick-for-week 2 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 2")))