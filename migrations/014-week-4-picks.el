(require 'db)

(migration 14
  (up (let ((picks (fixture "week-4-picks.elf")))
	(mapcar #'(lambda (plr-pick)
		    (apply #'insert-pick-for-week 4 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 4")))