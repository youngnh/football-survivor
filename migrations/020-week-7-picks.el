(require 'db)

(migration 20
  (up (let ((picks (fixture "week-7-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 7 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 7")))