(require 'db)

(migration 12
  (up (let ((picks (fixture "week-3-picks.elf")))
	(mapcar #'(lambda (plr-pick)
		    (apply #'insert-pick-for-week 3 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 3")))