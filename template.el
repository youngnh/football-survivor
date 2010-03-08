(require 'db)
(require 'utils)
(require 'sendmail)

(defun elt-expr (form)
  `(format ,(format "%%%s" (car form)) ,(second form)))

(defun process-template ()
  (let ((m (point-marker)))
    (if (search-forward "%" nil t)
        (concat
         (buffer-substring (marker-position m) (1- (point)))
         (eval (elt-expr (read (current-buffer))))
         (process-template))
      (buffer-substring (marker-position m) (point-max)))))

(defun template (filename)
  (let ((templ filename))
    (with-temp-buffer
      (insert-file-contents templ)
      (process-template))))

(defun insert-header (headers)
  (if (null headers)
      (insert "--text follows this line--\n")
    (let ((header (car headers))
          (value (cadr headers)))
      (insert (format "%s: %s\n"
                      (capitalize (substring (symbol-name header) 1))
                      value))
      (insert-header (cddr headers)))))

(defmacro context-for-week (&rest body)
  (declare (indent 0))
  `(let* ((results (full-results week))
          (matchups (join "\n" (mapcar #'(lambda (matchup)
                                           (apply #'format "%s at %s" matchup))
                                       (next-week-sched week))))
          (survivors (survivors results))
          (failures (failures results))
          (deadline (minute-before-kickoff (1+ week))))
     ,@body))

(defun survivors (results)
  (or (comma-tize (mapcar #'format-player-and-pick (remove-if-not #'survivedp results)))
      "nada"))

(defun failures (results)
  (or (comma-tize (mapcar #'format-player-and-pick (remove-if-not #'failedp results)))
      "nada"))

(defun send-emails (week)
  (interactive "P")
  (context-for-week
    (mapcar #'(lambda (x)
                (unless (string= "No Pick" (second x))
                  (with-temp-buffer
                    (user-email x)
                    (sendmail-send-it))))
            results)))

(defun user-email (player-line)
  (let ((templ (cond ((failedp player-line) "failure-email.elt")
                     ((thursday-gamep week) "thursday-reminder-email.elt")
                     (t "success-email.elt"))))
    (destructuring-bind (player pick score opponent oppo-score) player-line
      (let ((all-picks (comma-tize (all-player-picks player week)))
            (email (email-addr player))
            (msgid (message-id player week)))
        (insert-header (list :from "Nate Young <nate.young@asolutions.com>"
                             :to (format "\"%s\" <%s>" player email)
                             :in-reply-to (format "<%s>" msgid)
                             :subject (format "Asynchrony NFL Survivor Pool - Week %d" (1+ week))))
        (insert (template templ))))))

(defun survivedp (line)
  (and (not (string= (second line) "No Pick"))
       (> (third line) (fifth line))))

(defun failedp (line)
  (or (string= (second line) "No Pick")
      (< (third line) (fifth line))))

(defun format-player-and-pick (line)
  (format "%s (%s)" (first line) (second line)))

(defun email-addr (username)
  (caar (select (format "select email from users where username='%s'" username))))

(defun message-id (username week)
  (caar (select (format "select email_id from picks where username='%s' and week=%d" username week))))

(defun week-results (week)
  (select (format "select username, pick, home_score, away_team, away_score from picks join matchups on picks.pick = matchups.home_team where picks.week=%d and matchups.week=%d union select username, pick, away_score, home_team, home_score from picks join matchups on picks.pick = matchups.away_team where picks.week=%d and matchups.week=%d" week week week week)))

(defun full-results (week)
  (let ((results (week-results week)))
    (append results
            (mapcar #'(lambda (plr) (list (first plr) "No Pick"))
                    (set-difference
                     (remove-if-not #'survivedp (week-results (1- week)))
                     results
                     :test #'string= :key #'first)))))

(defun all-player-picks (player week)
  (mapcar #'first (select (format "select pick from picks where username='%s' and week<=%d order by week" player week))))

(defun next-week-sched (week)
  (select (format "select away_team, home_team from matchups where week=%d order by kickoff" (1+ week))))

(defun minute-before-kickoff (week)
  (let* ((kickoff (caar (select (format "select kickoff from matchups where week=%d order by kickoff" week))))
         (cutoff (seconds-to-time (- (float-time kickoff) 60))))
    (join " " (split-string (format-time-string "%l:%M %p, %b. %e" cutoff)))))

(defun thursday-gamep (week)
  (let* ((kickoff (caar (select (format "select kickoff from matchups where week=%d order by kickoff" week))))
         (cutoff (seconds-to-time (- (float-time kickoff) 60))))
    (string= "4" (format-time-string "%u" cutoff))))
