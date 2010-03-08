(require 'db)

(defcol email-id-col on picks
  (column email-id "varchar(100)"))

(migration 8
  (up (email-id-col-up))
  (down (email-id-col-down)))
