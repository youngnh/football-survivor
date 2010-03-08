(require 'db)

(migration 18
  (up (let ((picks (fixture "week-6-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 6 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 6")))