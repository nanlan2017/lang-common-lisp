(defun atom? (x)
  (not (listp x)))

(defparameter a "s-a")
(defparameter q1 '(a "s2" b 4))
(car q1)             ; 'a
(symbolp (car q1))   ; #t
(cadr q1)            ; "s2"
(symbolp (cadr q1))  ; #f

(defparameter q2 `(,a "s2" b 4))  ;; ▇▇▇▇▇▇▇▇▇▇▇▇ 此时a由identifer 替换为其值
;; === '("s-a" "s2" b 4)
(defparameter q3 `(,a "s2" ,@(list 3 4)))
