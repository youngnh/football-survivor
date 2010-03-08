(require 'db)

(migration 36
  (up (let ((scores (fixture "week-14-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 14 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=14")))