(require 'db)

(migration 31
  (up (let ((picks (fixture "week-12-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 12 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 12")))