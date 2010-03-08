(require 'db)

(migration 13
  (up (let ((scores (fixture "week-3-scores.elf")))
	(mapcar #'(lambda (matchup)
		    (apply #'insert-score 3 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=3")))