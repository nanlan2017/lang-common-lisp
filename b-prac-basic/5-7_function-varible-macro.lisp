;;; keyword parameter
(defun foo (&key a (b 20) (c 30 c-p)) (list a b c)) ; bad.  c-p can be used
(defun foo2 (&key a (b 20) (c 30 c-p)) (list a b c c-p))

;;; code example : 
(defun verbose-sum (x y)
  "this is function: verbose-sum's  documentation "			; documention string
  (format t "summing ~d and ~d.~%" x y)
  (+ x y))

					; =======================  test( =======================
					;
(documentation 'verbose-sum 'function)
					;
					;

(defun ret-test (n)
  (dotimes (i 10)
    (dotimes (j 10)
      (when (> (* i j) n)
	;; using "return-from"
	(RETURN-FROM ret-test (list i j))))))
					; =======================  test( =======================
					;
(ret-test 36)				; ==>  (5 8)      ; 5*7=35   < 36   <  5*8=40
					;
					;
;;; FUNCTION   #'   :  acqurie the function-object
(defun twice (x)
  (* 2 x))

					; =======================  test( =======================
					;
(FUNCTION twice)
#'twice#'twice
					;
					;-----------------------------------------------------
(defun paint (fn min max step)
  (loop for i from min to max by step do
       (loop repeat (FUNCALL fn i) do (format t "*"))
       (format t "~%")))

					;======================= test( ===================
(paint #'exp 0 4 1/2)
					;
					;
;; (setq param-list1 '(exp 0 4 1/2))
;; (setq param-list2 '(0 4 1/2))
;;; APPLY
(APPLY #'paint param-list1)
(APPLY #'paint #'exp param-list2)
;;****************************************** Lexical Varibles **********************************

(let ((count 0))
  #'(lambda () (setf count (1+ count)))) ; 1+  is  a  function  (no 2+ ...)

;; NOT a dead state function :   -> () (setf 0 1)
(defparameter *fn*			; *fn* :  a function object (has its own state)
  (let ((count 0))
    #'(lambda () (setf count (1+ count)))))
					;======================= test( ===================
(funcall *fn*) 				;==>  1
(funcall *fn*)  			;==>  2

;;********************************* macro : when ****************************
(defmacro when& (condition &rest clauses)
  `(if ,condition (progn ,@clauses)))

(when& t (format t "h") (format t "j"))


;;****************************************************************
;; dolist
(dolist (i '(1 2 3)) (print i) (if (evenp i) (return)))

;; dotimes  === Ruby :  10.times do |i| {...}
(dotimes (i 4) (print i))

;; do
(do ((i 0 (1+ i))) 			; var-list
    ((>= i 4))				; end-form 
  (print i))				; body

(do ((i 0 (1+ i)))
    ((>= i 4))
  (print i)
  (sleep 1))

;; LOOP




