(require 'db)

(defun insert-matchup (week date away-team home-team time)
  (with-pg-connection conn (*db* *user* *passwd*)
    (pg:exec conn (format "insert into matchups (week, home_team, away_team, kickoff) values (%d, '%s', '%s', '%s %s');" week home-team away-team date time))))

(migration 2
  (up (let ((schedule (fixture "schedule.elf")))
	(mapcar #'(lambda (matchup) (apply #'insert-matchup matchup)) schedule)))
  (down (exec-in-current-db "delete from matchups;")))