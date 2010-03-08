(require 'db)

(migration 29
  (up (let ((picks (fixture "week-11-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 11 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 11")))