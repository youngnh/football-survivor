(require 'db)

(migration 37
  (up (let ((picks (fixture "week-15-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 15 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 15")))