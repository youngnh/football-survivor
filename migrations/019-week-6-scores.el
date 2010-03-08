(require 'db)

(migration 19
  (up (let ((scores (fixture "week-6-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 6 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=6")))