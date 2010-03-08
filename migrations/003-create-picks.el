(require 'db)

(deftable pick
  (column pick-id "serial")
  (column username "varchar(20)")
  (column pick "varchar(20)")
  (column week "int"))

(migration 3
  (up (pick-up))
  (down (pick-down)))