(require 'db)

(migration 32
  (up (let ((scores (fixture "week-12-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 12 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=12")))