(require 'db)

(migration 34
  (up (let ((scores (fixture "week-13-scores.elf")))
        (mapcar #'(lambda (matchup)
                    (apply #'insert-score 13 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=13")))