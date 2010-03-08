(require 'db)

(deftable conference
  (column conference-id "serial")
  (column name "char(3)"))

(migration 39
  (up (conference-up))
  (down (conference-down)))
