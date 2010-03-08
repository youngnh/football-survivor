(require 'db)

(defun insert-message-ids (name msg-id)
  (exec-in-current-db 
   (format "update picks set email_id='%s' where username='%s' and week=1" 
	   msg-id name)))

(migration 9
  (up (let ((emailids (fixture "email-ids-week1.elf")))
	(mapcar #'(lambda (line)
		    (apply #'insert-message-ids line)) emailids)))
  (down (exec-in-current-db "update picks set email_id=NULL where week=1")))