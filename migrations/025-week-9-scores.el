(require 'db)

(migration 25
  (up (let ((scores (fixture "week-9-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 9 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=9")))
