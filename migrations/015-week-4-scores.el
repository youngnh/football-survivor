(require 'db)

(migration 15
  (up (let ((scores (fixture "week-4-scores.elf")))
	(mapcar #'(lambda (matchup)
		    (apply #'insert-score 4 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week=4")))