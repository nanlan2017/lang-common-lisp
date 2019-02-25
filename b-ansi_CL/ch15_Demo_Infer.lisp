
;; "事实" ::
;;      (predict  ?x)
;;      (relation ?x  ?y)

;;
(male ?x)		      ; x是男的
;; (is-#-of A  B)   ====>   A  is-#-of B
(parent donald nancy)
(daughter)
(child)
(female)

;; "推断"
;; (<- then-part   if-part)
(<- (child ?x ?y) (parent ?y ?x))
(<- (father ?x ?y) (and (parent ?x ?y) (male ?x))) ; T
(<- (daughter ?x ?y) (and (child ?x ?y) (female ?x)))


;; ------------ patter-match-checker : 看两个列表能否匹配
;; 我们有一个 match 函数，它接受两棵树，如果这两棵树能匹配，则返回一个关联列表（assoc-list）来显示他们是如何匹配的
(defun match (x y &optional binds)
  (cond
    ;; 如果 x 和 y 都是 cons ，并且它们的 car 匹配，由此产生的绑定又让 cdr 匹配，那么它们匹配
    ((eql x y)           (values binds t))
    ;; 如果 x 是一个已绑定的变量，并且绑定匹配 y ，那么它们匹配；
    ((assoc x binds)     (match (binding x binds) y binds))
    ;; 如果 y 是一个已绑定的变量，并且绑定匹配 x ，那么它们匹配
    ((assoc y binds)     (match x (binding y binds) binds))
    ;; 如果 x 是一个未绑定的变量，那么它们匹配，并且为 x 建立一个绑定
    ((var? x)            (values (cons (cons x y) binds) t))
    ;; 如果 x 是一个未绑定的变量，那么它们匹配，并且为 x 建立一个绑定
    ((var? y)            (values (cons (cons y x) binds) t))
    ;; 如果 x 和 y 都是 cons ，并且它们的 car 匹配，由此产生的绑定又让 cdr 匹配，那么它们匹配
    ;; ★通过递归实现迭代！
    (t
     (when (and (consp x) (consp y))
       (multiple-value-bind (b2 yes)
                           (match (car x) (car y) binds) ; 此处是对一对元素真正进行求值的地方。
        (and yes (match (cdr x) (cdr y) b2)))))))

;; 变量：第一个字母是?的 符号
(defun var? (x)
  (and (symbolp x)
       (eql (char (symbol-name x) 0) #\?)))

;; binds是一个map,x是一个符号--> get x 绑定的东西 from binds--> 
(defun binding (x binds)
  (let ((b (assoc x binds)))
    (if b
        (or (binding (cdr b) binds)
            (cdr b)))))

					;```````````````````````````````
;; 很简单哪：比如两个表   '(1 2 a 7)  '(x y 5 7)   能否匹配： 让 (x  1) (y 2) (a 5) 即可———— 这个已有绑定就是binds
;;    binding的过程，就是为变量?v 赋值的过程。
;;      
(match '(p a b c a) '(p ?x ?y c ?x))
;;-->
((?Y . B) (?X . A))
T

(match '(p ?x b ?y a) '(p ?y b c a))
;;-->
((?Y . C) (?X . ?Y))
T

(match '(a b c) '(a a a))
;;-->
NIL

(match '(a ?b) '(a ?c))
;;-->
((?B . ?C))
T

(match '(a (b c)) '(a ?x))
;;-->
((?X B C))
T
;;***********************************************************************
(defvar *rules* (make-hash-table))

(defmacro <- (con &optional ant)
  `(length (push (cons (cdr ',con) ',ant)
                 (gethash (car ',con) *rules*))))

;; 无body部分，即：给出一个fact
(<- (parent donald nancy))
;; -->
(length
 (push (cons (cdr '(parent donald nancy)) 'nil)
       (gethash (car '(parent donald nancy)) *rules*)))

;;-->  push (cons '(donald nancy) 'nil)
;;          (gethash 'parent *rules*)
