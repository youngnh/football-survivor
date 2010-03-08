(require 'db)

(migration 23
  (up (let ((scores (fixture "week-8-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 8 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=8")))