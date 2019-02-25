(defmacro head (lst)
  `(car ,lst))
(defmacro tail (lst)
  `(cdr ,lst))

(head (list 1 2))
(tail 列表)

;;*********  列表的 共享结构

;;*********  quene 队列 （直接用Cons，并提供deque,enquene)
(defun make-quene ()
  (cons nil nil))

;; 把列表头部元素弹出
(defun dequene (q)
  (pop (car q)))

;; 在列表的尾部插入
(defun enqueue (obj q)
  (if (null (car q))
      (setf (cdr q) (setf (car q) (list obj)))
      (setf (cdr (cdr q)) (list obj)
            (cdr q) (cdr (cdr q))))
  (car q))
      
(declaim (fixnum *count*))

(defclass smallInt (integer 1 10))

;;*************************************************************************


(typep 233 '(integer 1 100))	; NIL
;;  small-int ::  值位于1~100间的整数 
(deftype small-int ()  '(integer 1 100))
(typep 12 'small-int)			;==> T
(typep 233 'small-int)			;==> Nil

;; union类型（a/b类型) --通过 or
(deftype int-or-string () '(or integer string))
(typep 12 'int-or-string)
(typep "ha" 'int-or-string)
(typep '(1 2) 'int-or-string)

;; satisfies
(deftype multiple-of (n)
  `(and integer
	(satisfies (lambda (x)
                      (zerop (mod x ,n))))))
(typep 12 '(multiple-of 4))

(deftype ttt () '(and integer '(satisfies (lambda (x)
					    (zerop (mod x 4))))))


(set-macro-character #\'
        #'(lambda (stream char)
                (list (quote quote) (read stream t nil t))))
