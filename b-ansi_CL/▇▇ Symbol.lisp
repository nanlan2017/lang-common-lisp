					;
					; 来源：
					;     https://yq.aliyun.com/articles/4114
					;http://www.cppblog.com/kevinlynx/archive/2011/03/22/142462.html
					;

;; Lisp中，符号的类型是 SYMBOL
;; 符号和整数其实差不多，只不过一个是用数字表示的，而符号使用字母表示  （理解成一种特殊的string)
;;     Symbol = Could-bounded-String  ▇▇▇▇▇▇▇▇ 符号，是"一种可以绑定到东西的String"
;;     其实就是Java中的 Object型的Reference Varible(“引用变量”）————不过在Lisp中不限定其绑定的类型
(TYPE-OF 'a)				;==>  SYMBOL
;; ② String 有变量名+ literal   :   (setf str "I love you")
;;    Symbol 也是的！？？
;;   相同的符号总是eq的
(eq 'a 'a)				;==> T


;;------------------------------------------------------

;;;  一个symbol，可以同时 binding 到 function / varible / class 上
;;  ▇▇▇▇▇▇▇▇ 即  函数、变量、类 可以使用同一个命名！
(map 'list #'SYMBOL-NAME (loop for s being the symbol collect s)) ;==>  一堆结果！当前可见的所有symbols!

					; 查找是否有 'a 这个symbol
(find "A" (map 'list #'symbol-name (loop for s being the symbol collect s)) :test #'string=) ;==> NIL

(setf a "ddd")				;==> error : undefined varible : A

(find "A" (map 'list #'symbol-name (loop for s being the symbol collect s)) :test #'string=) ;==>"A"

;;---------------------
;; 'a 已绑定到了一个变量？
(boundp 'a)				; 'a 是否已绑定：T   (  a 这个符号是否已经被绑定了实体定义   ）


(defun a () ()) 			; 定义一个叫a的函数
(fboundp 'a)				; 'a是否绑定到了一个函数 ： T

(defclass a () ())	                ; 定义一个叫a的类
(find-class 'a)				; #<STANDARD-CLASS COMMON-LISP-USER::A>

;; ③ struct和 class不能绑定到同一个symbol上 （ ▇▇▇▇▇▇▇▇即： struct和class不能同名！）
(defstruct a x y)


;;*********************************************************************
(defun add-10 (x)
  (+ 10 x))

(add-10 1)
(type-of #'add-10)			;==> FUNCTION

(defun get-add-x (x)
  (lambda (y) (+ x y)))

(defun apply-fn (f n)
  (funcall f n))

(funcall #'add-2 1)
(apply-fn #'add-2 1)

(defvar add-3 #'(lambda (x) (+ 3 x)))
CL-USER> add-3
;; #<FUNCTION (LAMBDA (X)
;;              :IN
;;              "/Users/jiaheng/workspace/lisp_wsp/b-ansi_CL/test-1.lisp") {225F5D7B}>
;; CL-USER> (type-of add-3)
;; FUNCTION
;; CL-USER> (type-of 'add-3)
;; SYMBOL
;; CL-USER> 
(type-of add-3)
(funcall #'add-3 1)

(get 'alizarin 'color)

;;;****************************************************
;;; symbol对象有5个域： name, package, value , function, plist
;; name : 绑定其字面（为一字符串）
;; package : 定义的包 ( 包是 name <--> symbol的 map)
;; value, function, plist
;;  ??? 如何绑定一个类？
(defvar *var* 1)
(boundp '*var*)				; T
(fboundp '*var*)			; nil

(defun *var* (x) (+ 1000 x))
(fboundp '*var*)			; T

(defclass *var* () ())
(find-class '*var*)

(get '*var* 'color)
(setf (get '*var* 'color) "RED")
(setf (get '*var* 'area) "JiangSu")


;; 
(symbol-name '*var*)			; "*VAR*"
(symbol-package '*var*)			; #<PACKAGE "COMMON-LISP-USER">
(symbol-value '*var*)			; 1
(symbol-function '*var*)		; #<FUNCTION *VAR*>
(symbol-plist '*var*)			; (AREA "JiangSu" COLOR "RED")



;;;  ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ defvar *v* /  defun *v* 这些宏做的本质其实是 实例化了一个symbol instance，
;;;  ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇                    并给它的 varible/ function域赋值
;;;
(*var* *var*)				; 1001   第一个被当做函数，第二个被当做变量



;; 错误原因：  *var*被求值为1, 则等价于 (symbol-name 1)， 而 1不是symbol，故报错！
(symbol-name *var*)

;;
(defvar *name* "kevin lynx")
(defvar *ref* '*name*) ; ▇▇▇▇▇▇▇▇▇ *ref*的Value保存的是另一个Symbol
(symbol-value *ref*) ; 取*ref*的Value，得到*name*，再取*name*的Value
;;;========> 结论：(defvar s #)是定义一个symbol instance ： 's ，并赋它的value域为 #
;;*******************************************************

;; 解释：
(defvar fn #'(lambda (x) (* 1000 x)))
(fn 3) ;; 报错！
;; 因为 这个lambda函数是保存在'fn的value域
;; 而 (fn 3)会试图从'fn的function域获取函数，当然不存在！

(setf (symbol-function 'fn) #'(lambda (x) (* 1000 x)))
(fn 3) ;; 正确！

(defmacro check-symbol (sym)
  `(progn
     ,(symbol-name sym)
     ,(symbol-package sym)
     ,(symbol-value sym)
     ,(symbol-function sym)
     ,(symbol-plist sym)))

(check-symbol 'fn)
((symbol-function 'fn) 3) ;; Illegal function call !!!


(defun fook (x) 3)
(type-of (symbol-function 'fook))
(fook 0) ;;  ----- 编译器自行将另一个名字作为 symbol,取其functon域所绑定的函数！ 而不是你手动来取！
(setf (symbol-function 'fook) 3)
(#'fook)


(defvar a1 "1")

(let ((b1 "2"))
  (message ))

(message "%s" b)


;;********************************************************************************
;;********************************************************************************
;;********************************************************************************
;;********************************************************************************
;;********************************************************************************
;; https://yq.aliyun.com/articles/229063?spm=a2c4e.11153940.blogcont229064.15.6041984chxNSAo


(defvar *t1* 0)

(defun inc (var)
    (list 'setq var (list '1+ var)))


(inc 'x)    ; (setq x (1+ x))
(type-of (inc 'x))  ; ==>  LIST == Cons

(inc *t1*)  ; '(setq 0 (1+ 0)    得到一个列表 ------ eval会报错！

(inc '*t1*) ; '(setq *t1* (1+ *t1*)   这个才是正确的！
(eval (inc '*t1*))   ;;  eval : 调用求值器，把返回的列表当做code来执行


					;------------ 改为macro
(defmacro inc-m (var)
  (list 'setq var (list '1+ var)))

(inc-m *t1*)   ;  等同于直接写代码：    (setq *t1* (1+ *t1*)
