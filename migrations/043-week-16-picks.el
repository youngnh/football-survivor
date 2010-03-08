(require 'db)

(migration 43
  (up (let ((picks (fixture "week-16-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 16 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 16")))