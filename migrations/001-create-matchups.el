(require 'db)

(deftable matchup
  (column matchup-id "serial")
  (column week "int")
  (column home-team "varchar(50)")
  (column away-team "varchar(50)")
  (column home-score "int")
  (column away-score "int")
  (column kickoff "timestamp"))

(migration 1
  (up (matchup-up))
  (down (matchup-down)))
