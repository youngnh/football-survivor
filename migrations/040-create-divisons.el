(require 'db)

(deftable division
  (column division-id "serial")
  (column name "varchar(9)")
  (column conference "integer"))

(migration 40
  (up (division-up))
  (down (division-down)))