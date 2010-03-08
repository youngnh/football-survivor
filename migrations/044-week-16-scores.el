(require 'db)

(migration 44
  (up (let ((scores (fixture "week-16-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 16 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=16")))