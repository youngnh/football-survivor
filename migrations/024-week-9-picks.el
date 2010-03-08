(require 'db)

(migration 24
  (up (let ((picks (fixture "week-9-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 9 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 9")))