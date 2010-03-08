(require 'db)
(require 'email-parsing)

(defun generate-scores-fixture (week)
  (interactive "p")
  (let ((filename (format "migrations/week-%d-scores.elf" week)))
    (save-excursion
      (set-buffer (find-file filename))
      (lisp-mode)
      (print-list (select (format "select away_team, home_team from matchups where week=%d" week)))
      (indent-region (point-min) (point-max))
      (save-buffer))))

;;(loop for w from 7 to 17 do (generate-scores-fixture w))

(defun generate-picks-fixture (week buf)
  (interactive "p\nsBuffer: ")
  (let ((filename (format "migrations/week-%d-picks.elf" week))
        (emails (process-mbox buf)))
    (save-excursion
      (set-buffer (find-file filename))
      (lisp-mode)
      (print-list
       (mapcar #'(lambda (msg)
                   (list (first msg)
                         ""
                         (third msg))) emails))
      (indent-region (point-min) (point-max))
      (save-buffer))))

(defun print-list (lst)
  (princ "(" (current-buffer))
  (mapcar #'(lambda (expr)
              (prin1 expr (current-buffer))
              (terpri (current-buffer)))
          lst)
  (princ ")" (current-buffer)))


;; (generate-picks-fixture 5 "mbox")