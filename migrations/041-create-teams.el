(require 'db)

(deftable team
  (column team-id "serial")
  (column name "varchar(50)")
  (column division "integer"))

(migration 41
  (up (team-up))
  (down (team-down)))