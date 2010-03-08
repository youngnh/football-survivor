(require 'db)

(migration 33
  (up (let ((picks (fixture "week-13-picks.elf")))
        (mapcar #'(lambda (plr-pick)
                    (apply #'insert-pick-for-week 13 plr-pick)) picks)))
  (down (exec-in-current-db "delete from picks where week = 13")))