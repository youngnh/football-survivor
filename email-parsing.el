(require 'utils)

(defun next-n-lines (n)
  (if (> n 0)
      (let ((start (point)))
        (if (search-forward "\n" nil t)
            (concat (buffer-substring start (point))
                    (next-n-lines (1- n)))
          ""))
    ""))

(defun 1-line ()
  (substring (next-n-lines 1) 0 -1))

(defun read-headers ()
  (let ((headers nil))
    (loop for line = (1-line)
          until (string= "" line)
          do (if (string-match "^[ \t]" line)
                 (let ((val (second (car headers))))
                   (setf (second (car headers)) (concat val line)))
               (push (split-on-first line ":") headers)))
    (nreverse headers)))

(defun process-email ()
  (let ((h (read-headers)))
    (let ((from (or (second (assoc "From" h)) ""))
          (msgid (or (second (assoc "Message-ID" h)) ""))
          (subject (or (second (assoc "Subject" h)) ""))
          (inreplyto (or (second (assoc "In-Reply-To" h)) "<>")))
      (list (re-string-match " \?\"\?\\([^\"]*\\)\"\? <\?\\(.*\\)>\?$" from 1)
            (re-string-match "\\(.*\\) <\?\\(.*\\)>\?$" from 2)
            (re-string-match "<\\(.*\\)>$" msgid 1)
            (re-string-match "<\\(.*\\)>$" inreplyto 1)
            (concat subject
                    "\n"
                    (next-n-lines 5))))))

(defun process-mbox (buf)
  (save-excursion
    (set-buffer buf)
    (goto-char 0)
    (setq case-fold-search nil)
    (loop while (search-forward "From " nil t)
          collect (progn
                    (search-forward "\n")
                    (process-email)))))

(provide 'email-parsing)