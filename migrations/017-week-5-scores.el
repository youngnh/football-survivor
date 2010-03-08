(require 'db)

(migration 17
  (up (let ((scores (fixture "week-5-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 5 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=5")))