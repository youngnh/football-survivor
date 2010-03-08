(require 'db)

(migration 27
  (up (let ((picks (fixture "week-10-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 10 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 10")))