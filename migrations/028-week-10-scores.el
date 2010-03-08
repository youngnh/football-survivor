(require 'db)

(migration 28
  (up (let ((scores (fixture "week-10-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 10 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=10")))