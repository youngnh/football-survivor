(require 'db)

(deftable user
  (column user-id "serial")
  (column username "varchar(20)")
  (column email "varchar(50)"))

(migration 6
  (up (user-up))
  (down (user-down)))