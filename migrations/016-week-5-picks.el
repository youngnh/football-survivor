(require 'db)

(migration 16
  (up (let ((picks (fixture "week-5-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 5 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 5")))