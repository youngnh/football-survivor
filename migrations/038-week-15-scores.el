(require 'db)

(migration 38
  (up (let ((scores (fixture "week-15-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 15 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=15")))