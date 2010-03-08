(require 'db)

(migration 21
  (up (let ((scores (fixture "week-7-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 7 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=7")))