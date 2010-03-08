(require 'db)

(migration 22
  (up (let ((picks (fixture "week-8-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 8 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 8")))