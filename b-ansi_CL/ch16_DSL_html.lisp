(defmacro as (tag content)
  `(format t "<~(~A~)>~A</~(~A~)>"
           ',tag ,content ',tag))

(defmacro with (tag &rest body)
  `(progn
     (format t "~&<~(~A~)>~%" ',tag)
     ,@body
     (format t "~&</~(~A~)>~%" ',tag)))

(defmacro brs (&optional (n 1))
  (fresh-line)
  (dotimes (i n)
    (princ "<br>"))
  (terpri))

					;`````````````````````````````````````
(as center "The Missing Lambda")
(with center
   (princ "The Unbalanced Parenthesis"))
					;,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,

(defun html-file (base)
  (format nil "~(~A~).html" base))

;; 只给我 name, title , body 可以生成 一个网页的完整代码
(defmacro page (name title &rest body)
  (let ((ti (gensym)))
    `(with-open-file (*standard-output*
                      (html-file ,name)
                      :direction :output
                      :if-exists :supersede)
       (let ((,ti ,title))
         (as title ,ti)
         (with center
           (as h2 (string-upcase ,ti)))
         (brs 3)
         ,@body))))
