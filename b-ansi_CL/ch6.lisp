;; 多值
(defun ret-multi-vars ()
  (values 1 2))

(multiple-value-bind (v1 v2) (ret-multi-vars)
  (list v1 v2))

(multiple-value-list (ret-multi-vars))

;;***********************************************
;; 闭包与共享变量 —— counter类似一个全局变量、但只对这几个函数可见
(let ((counter 0))
  (defun reset0 ()
    (setf counter 0))
  (defun stamp ()
    (setf counter (1+ counter))))

(list (stamp) (stamp) (reset0) (stamp))


;;************************************************ 编写一些常用的函数式API
;; complement : 给定f， (complement f) 总能对f的调用结果返回not值
(defun my-complement (f)
  (lambda (&rest args) (not (apply f args))))

					;`````````````````````
(mapcar (my-complement #'evenp) '(1 2 3 4))


;; Haskell   .  函数combination (compose)
(defun my-compose (f g)			; 先g后f
  #'(lambda (&rest args) (apply g (apply f args))))

					;``````````````````````
(funcall (my-compose #'(lambda (x) (+ x 4)) #'print) 2)
;;***********************************************

(defun compose (&rest fns)
  (destructuring-bind (fn1 . rest) (reverse fns)
    #'(lambda (&rest args)
        (reduce #'(lambda (v f) (funcall f v))
                rest
                :initial-value (apply fn1 args)))))


(defun disjoin (fn &rest fns)
  (if (null fns)
      fn
      (let ((disj (apply #'disjoin fns)))
        #'(lambda (&rest args)
            (or (apply fn args) (apply disj args))))))


(defun conjoin (fn &rest fns)
  (if (null fns)
      fn
      (let ((conj (apply #'conjoin fns)))
        #'(lambda (&rest args)
            (and (apply fn args) (apply conj args))))))



;;----------------
(defun curry (fn &rest args)
  #'(lambda (&rest args2)
      (apply fn (append args args2))))

(defun rcurry (fn &rest args)
  #'(lambda (&rest args2)
      (apply fn (append args2 args))))

(defun always (x) #'(lambda (&rest args) x))

;;****************************************************************
(let ((x 10))
  (defun foo ()
    x))
(let ((x 20)) (foo))



(let ((x 10))
  (defun foo ()
    (declare (special x))
    x))

(declare (special x) (special y)


	 )


(let ((sv 5))
  (eval
   (funcall #'(lambda (x) (+ x sv))
	  3)))
