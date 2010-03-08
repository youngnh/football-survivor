(defun join (with strs)
  (if (> (length strs) 1)
      (concat (first strs) with (join with (rest strs)))
    (first strs)))

(defun comma-tize (vals)
  (join ", " vals))

(defun positional (num)
  (let ((suffix (case (mod num 10)
                  (1 "st")
                  (2 "nd")
                  (3 "rd")
                  (t "th"))))
    (format "%d%s" num suffix)))

(defmacro re-string-match (regexp str n)
  (let ((ismatchvar (gensym))
        (strvar (gensym))
        (nvar (gensym)))
    `(let ((,strvar ,str)
           (,nvar ,n))
       (let ((,ismatchvar (string-match ,regexp ,strvar)))
         (if ,ismatchvar
             (substring ,strvar (match-beginning ,nvar) (match-end ,nvar)))))))

(defmacro in-dir (dir &rest body)
  (declare (indent 1))
  (let ((orig-dirvar (gensym))
        (resultvar (gensym)))
    `(let ((,orig-dirvar default-directory))
       (cd ,dir)
       (let ((,resultvar (progn ,@body)))
         (cd ,orig-dirvar)
         ,resultvar))))

(defun split-on-first (string delim)
  (let ((index (string-match delim string)))
    (if index
        (list (substring string 0 index) (substring string (1+ index)))
      string)))

(provide 'utils)