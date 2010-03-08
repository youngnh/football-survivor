(require 'db)

(migration 11
  (up (let ((scores (fixture "week-2-scores.elf")))
	(mapcar #'(lambda (matchup)
		    (apply #'insert-score 2 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week = 2")))