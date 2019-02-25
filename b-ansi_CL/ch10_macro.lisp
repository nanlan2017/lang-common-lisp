;;  当你写下 'xxx 的时候， 这个 xxx 就已经实例化为一个 Symbol instance （不过还未绑定值、函数）
;;  Symbol对象的字面写法都是 'xxx ，
;;  要分清楚：
;;    1.  求值策略 （函数调用时如何求值、quote、#' 、宏调用时如何求值）
;;    2.  symbol, 全局变量名(特殊/动态)， 函数名  的绑定关系

;; function是特殊操作符，有特别的求值策略。所有把函数名直接写在后面没事！



;;  这3者等价！  #<FUNCTION +>
;;  返回的类型都是 FUNCTION
(function +)
#'+
(symbol-function '+)


;; 而使用一个Function对象时，要使用 funcall/ apply



(defun -eval (expr env)
  (cond
    ((eql 'quote (car expr)) (cdr expr)) ;;   eval 'x  ===>  x
    ;; 其他特殊操作符
    ;; 函数调用
    (t (apply (symbol-function (car expr)) ; 取出第一个元素：Function对象
	      ;; 实参要首先求值各参数为值列表
	      (mapcar #'(lambda (elem) (eval elem env)) (cdr expr))))))

;; 你在编辑器里写  (+  1 2)
;; 经过reader: 将其读为 CONS<Symbol> --- ('+  '1 '2)
;; 经过eval ，得到一个某类型的结果值
					;  apply (symbol-function '+) '(1 2)
;; print该类型的值
;;*************************************************************************************

;;  跨越代码与列表（数据）的界限

;; 1. eval
(eval '(+ 1 2))
(eval (list '+ '1 '2))
(eval (list '+ '(* 5 6) '1))		; 31
;; '(a b c)  === 'a 'b 'c

;; 2. coerce : 强制转换接下来的Cons-symbols 为 指定类型
(coerce '(lambda (x) (1+ x)) 'function)	; #<FUNCTION (LAMBDA (X)) {1001F780BB}> （解释器interpreter)

;; 3. compile
(compile 'add2 '(lambda (x) (+ x 2)))	; #<Compiled-Function add2>
;;*************************************************************************************
(defmacro nil! (x)
  (list 'setf x nil))

(nil! x)


;;  
;; 相当于产生了这样的一个 nil! 函数
(lambda (expr)
  (apply #'(lambda (x) (list 'setf x nil)) (cdr expr)))

					; cdr '(nil! x) ===>  'x
					; (lambda (x) (list 'setf x nil)) --> 'x  ====>  '(setf x nil)
;;**********************************************************************************
(let ((a 1)
      (b 2))
  `(a is ,a and b is ,b))		; '(A is 1 and b is 2)

(let ((lst '(a b c)))
  `(LIST is lst)
  `(LIST is ,lst)
  ;; `(LIST is ,@lst)
  
  )

(defmacro -while (test &rest body)
  `(do ()
       ((not ,test))
     body))
(-while (+ 1 2) fuck)

(pprint (macroexpand-1 '(-while (+ 1 2) fuck)))



;; dotimes
(defmacro dotimes (times expr))



;;  (incf x) --->  (setf x (+ x 1))
;;  (incf x n) ---> (setf x (+ x n))
(defmacro -incf (x &optional (n 1))
  (let ((m (gensym))
	(k (gensym))			; x 是词法作用域的symbol？ 可以吗？
    (let ((m x)
	  (k n))			; bind symbol:'k  to 
      `(setf ,m (+ ,m ,k))))))


(defparameter lst nil)

(defmacro our-incf (x &optional (y 1))
  `(setf ,x (+ ,x ,y)))

(our-incf (car (push 1 lst)))		; x 为 (car (push 1 lst))
;; ===>  (SETF (CAR (PUSH 1 LST)) (+ (CAR (PUSH 1 LST)) 1))
(setf (car (push 1 lst)) (1+ (car (push 1 lst)))) ;;  这和标准库提供的incf 不一样，

(define-modify-macro o-incr (&optional (y 1))
  +)

(o-incr (car (push 1 lst)))
;;   (DEFMACRO O-INCR (#:PLACE &OPTIONAL (Y 1) &ENVIRONMENT #:ENV)
;;  (expand-rmw-macro '+ 'NIL #:PLACE (LIST* Y NIL) T #:ENV '(Y)))
(incf (car (push 1 lst)))


(define-modify-macro append1f (val)  ;; 第一个隐含参数回事它的 place
  (lambda (lst val) (append lst (list val))))

;;*************************************************************************************
;; 把 for 语句 自动展开成 do语句
(defmacro for (var start stop &body body)
  (let ((gstop (gensym)))
    `(do ((,var ,start (1+ ,var))
          (,gstop ,stop))
         ((> ,var ,gstop))
       ,@body)))

(defmacro in (obj &rest choices)
  (let ((insym (gensym)))
    `(let ((,insym ,obj))
       (or ,@(mapcar #'(lambda (c) `(eql ,insym ,c))
                     choices)))))

(defmacro random-choice (&rest exprs)
  `(case (random ,(length exprs))
     ,@(let ((key -1))
         (mapcar #'(lambda (expr)
                     `(,(incf key) ,expr))
                 exprs))))

(defmacro avg (&rest args)
  `(/ (+ ,@args) ,(length args)))	; 用defun也可以，宏把其 length计算提前到 编译期

(defmacro with-gensyms (syms &body body)
  `(let ,(mapcar #'(lambda (s) `(,s (gensym)))
                 syms)
     ,@body))

(defmacro aif (test then &optional else)
  `(let ((it ,test))
     (if it ,then ,else)))
;;;;;;;;;;;;;; test-case ;;;;;;;;;;;;;;;;;
(avg 1 2 3)

(with-gensyms (name address age)
  (....body...))
;;(LET ((NAME (GENSYM)) (ADDRESS (GENSYM)) (AGE (GENSYM)))
;;   (....BODY...))

(for i 1 ("会产生一个end值的s-exp")
  (..利用i值的计算1..)
  (..i计算2.。))

(aif (calculate-something)
     (1+ it)
     0)

;;定义一个宏，接受一变量列表以及一个代码主体，并确保变量在代码主体被求值后恢复 (revert)到原本的数值。
;;------------------------- 样例 ----------------------------
(with-recover (a b c)
     (语句1)
     (语句2))

===>
(let ((a0 a)
      (b0 b)
      (c0 c))
  (语句1) (语句2)
  (progn
    (setf a a0)
    (setf b b0)
    (setf c c0)))  ;;  不对吧，本来 a0 a 就指向同一个对象？

;;-------------------------------  实现 ---------------------------
(defmacro with-recover (vars &rest body)
  ;; 根据vars 创建  var-old-s   _____ var的类型？ var-old如何生成
  ;;  '(a b c)  --->  '(a0 b0 c0)
  (let ((var-old-s (mapcar #'(lambda (var)
			       (intern (concatenate 'string (symbol-name var) "0")))
			   vars)))
    `(let ,(mapcar #'list var-old-s vars)
       ,@body
       (progn
	 ,@(mapcar #'(lambda (v vo)
		      (list 'setf v vo))
		  vars var-old-s)))))

;; test................................
(mapcar #'(lambda (var) (concatenate 'string (symbol-name var) "0"))
	'(a b c))
;; (mapcar #'(lambda (var) (concatenate 'symbol (symbol-name var) "0"))
;; 	'(a b c))

(mapcar #'type-of '(a b c))		; (SYMBOL SYMBOL SYMBOL)
					;  '(a b c)  === (list 'a 'b 'c)
(mapcar #'type-of (list 'a 'b 'c))
;;---------------------------  测试 ---------------------------
(defparameter hx 1)
(defparameter hy 2)
(defparameter hz 3)

(with-recover (hx hy hz)
     (incf hx)
     (incf hy)
     (incf hz)
     (print hx)
     (print hy)
     (print hz))

;; (let ((hx0 hx) (hy0 hy) (hz0 hz))
;;   (incf hx)
;;   (incf hy)
;;   (incf hz)
;;   (print hx)
;;   (print hy)
;;   (print hz)
;;   (PROGN (SETF HX HX0) (SETF HY HY0) (SETF HZ HZ0)))

;; *************************************************************
(push 值 列表)


(defstruct 矩形
  高
  宽)
