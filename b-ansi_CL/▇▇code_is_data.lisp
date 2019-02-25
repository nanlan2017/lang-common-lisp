(defvar op '+)
(defvar quoteList '(1 2 3))

(defun calc (op lst)
  (eval (cons op lst)))

(calc op quoteList)
;;----------------------- 揭示 --------------------------------------------------
;;;       举例： (+ 1 2)的语法树
;;;       syntax tree : 既是code, 也是data
;;;       对这个树进行eval，就会当成code进行求值、得到结果结点
;;;       对这个树进行quote,就会得到data的节点列表，可进行节点的读改
					;
					;
					;
;;   quote :  使得 code ---->  data  ==== 作为 symbols的cons/list-->tree，可以随意访问其中的结点
					; quote 使s-exp成为 symbols的cons !
;;   eval  :  使得 data ---->  code  ==== 用于对一枝子树（S-exp)求值
					; eval  对一段symbols的 cons进行求值！
					;
					;
;;====>  Macro的实质： 利用部分结点，构造一颗完整子树（将它们作为data进行处理、也可进行部分eval (宏展开时也可eval))


(defparameter tree '(+ 1 (* 2 3)))
(type-of tree)				; cons    ( tree of symbols)
(type-of 'tree)				; symbol  (根节点代表的子树，也可引用为一个symbol）

(car tree)				; +
(type-of (car tree))			; symbol

(cdr tree)				; (1 (* 2 3))
(type-of (cdr tree))			; CONS

(cadr tree)				; 1
(type-of (cadr tree))			; == (type-of '1) ===> BIT

;;--------------------- Cons , list , tree -------------------------------------
(type-of (list 1 2 3))			; CONS ----- Lisp中list的类型叫做“Cons”, 即列表   
(type-of (cons (cons 1 2) 3))		; cons函数：将 head 和 tail 进行连接
	                                ; [可嵌套的列表就是树]

;;  list函数是用cons实现的
(defun mklist (head &rest tail)	        
  (if tail
      (cons head tail)
      (cons head NIL)))  
;;------------------------------------------------------------------------------
(type-of '"love")			; 这是函数调用，首先会对实参进行eval，得到"love" (自求值对象）
(type-of '(+ 1 2))			; CONS 实参被quote , 让该实参不eval ?
(eval '(+ 1 2))				; 3
(type-of ''(+ 1 2))			; CONS   ==  '(quote (+ 1 2))
(type-of '+)				; SYMBOL
(type-of '(+ +))			; CONS
;; =====>  只要被quote了，它的type-of就肯定是 Symbol(单元素) 或 CONS (多元素）
