(require 'db)

(migration 30
  (up (let ((scores (fixture "week-11-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 11 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=11")))