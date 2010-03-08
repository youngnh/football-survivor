(require 'db)

(migration 35
  (up (let ((picks (fixture "week-14-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 14 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 14")))