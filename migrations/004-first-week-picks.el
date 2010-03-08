(require 'db)

(defun pick-for-week (week username pick)
  (with-pg-connection conn (*db* *user* *passwd*)
    (pg:exec conn (format "insert into picks (username, pick, week) values ('%s', '%s', %d)" username pick week))))

(migration 4
  (up (let ((picks (fixture "week-1-picks.elf")))
	(mapcar #'(lambda (plr-pick)
		    (apply #'pick-for-week 1 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 1")))