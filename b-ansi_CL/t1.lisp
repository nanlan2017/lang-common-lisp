; -*- lexical-binding: t -*-


;; ------------------------------------------------------
;; <Emacs之魂> :
;;             Lisp中列表对象用的非常多，每次都使用list函数来创建是一件麻烦的事情，
;;             因此，Lisp语言提供了列表对象的字面量写法，我们只需要调用quote就可以了。

;;  '(1 2 3)  和 (list 1 2 3)  是一样的吗？
;;  在REPL中看是一样的，都是得到  (1 2 3)
(type-of '(1 2 3))			; CONS
(type-of (list 1 2 3))			; CONS

(eq '(1 2 3) (list 1 2 3))		; NIL
(eql '(1 2 3) (list 1 2 3))		; NIL
(equal '(1 2 3) (list 1 2 3))		; T 
(equalp '(1 2 3) (list 1 2 3))		; T


;; eval 是 quote 的反运算
''1					; '1
''+  ; Error: illegal function call
(quote (quote (+)))			; '+
