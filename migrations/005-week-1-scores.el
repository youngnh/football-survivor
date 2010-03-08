(require 'db)

(defun insert-score (week away-team away-score home-team home-score)
  (exec-in-current-db 
   (format "update matchups set away_score=%d, home_score=%d where week=%d and away_team='%s' and home_team='%s'" away-score home-score week away-team home-team)))

(migration 5
  (up (let ((scores (fixture "week-1-scores.elf")))
	(mapcar #'(lambda (matchup)
		    (apply #'insert-score 1 matchup)) scores)))
  (down (exec-in-current-db "update matchups set away_score=NULL, home_score=NULL where week = 1")))