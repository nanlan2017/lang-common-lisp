;;example
(defparameter x1 0)
(defparameter x2 0)

;; ---------- 效果  ----------------
;; (setq2 v1 v2 e)

(progn
  (setq x1 0)
  (setq x2 0))

;; ------------ 定义 -------------
;; 函数写法
;; 得用 symbol 来调用. 也是可以实现的！（运行期求值时展开，还需手动eval结果的Cons-symbols)
(defun setq2F (v1 v2 e)
  (list 'progn (list 'setq v1 e) (list 'setq v2 e)))  ;; 这里v不能写死成符号v，必须进行求值！（but not used)
;; 函数+ `
(defun setq2F+ (v1 v2 e)
  `(progn (setq ,v1 ,e) (setq ,v2 ,e)))

;; Macro写法
(defmacro setq2M (v1 v2 e)
  (list 'progn (list 'setq v1 e) (list 'setq v2 e)))
;; Macro+ `
(defmacro setq2M+ (v1 v2 e)
  `(progn (setq ,v1 ,e) (setq ,v2 ,e)))

;; ---------- test -------------
(setq2F 'x1 'x2 1)                


(setq2F+ 'x1 'x2 3)


(setq2M x1 x2 2)


(setq2M+ x1 x2 4)


;;************************************************************************


(defparameter v '(1+ 2))
(defparameter k (1+ 2))
;;   作为语法树来讲    (1+ 2) 和  '(1+ 2) 的区别？
;;                "坍缩的”    “健壮的“(可读写的)
;;                  quote :  使得将坍缩的健壮 
;;                  eval  ： 使得健壮的坍缩
`(a ,@v v) ; (a 1+ 2) v)
`(a ,@k k)

`(a ,@v ,v) ; (a 1+ 2 (1+ 2))
`(a ,@k ,k)
;;************************************************************************
(defparameter li1 '(a 6 15))
(mapcan (lambda (x)
	  (cond ((symbolp x) `((,x)))
		((> x 10)    `(,x ,x))
		((>= x 0)    `(low))
		(t           '())))
        li1)

(defstruct dog name breed age)
(make-dog :name "rover"
	  :breed "collie"
	  :age 5)


(mapcar #'1+ '(1 2 3))             ; => '(2 3 4)
(mapcar #'+ '(1 2 3) '(10 20 30))  ; => '(11 22 33)
(remove-if-not #'evenp '(1 2 3 4)) ; => '(2 4)
(every #'evenp '(1 2 3 4))         ; => nil
(some #'oddp '(1 2 3 4))           ; => T
(butlast '(subject verb object))   ; => (SUBJECT VERB)

(setf g1 '(1 2))
g1
(setq g2 '(3 4))
g2

