(defun inc (var)
  (list 'setq var (list '1+ var)))

;;  (inc x) 是错误的，因为要传一个symbol给它 ! 这样函数调用的话， x作为实参会首先被eval、然后才与形参bind
;;  ▇▇▇▇▇▇▇▇ 如果 inc 是宏的话，宏调用会直接把 x 当做symbol (而不是先eval?), 就没问题！---（<宏调用的eval策略>)



(inc 'x)				;   (setq x (1+ x))
(type-of (inc 'x))			;  CONS (of symbols)

(defparameter x 0)
(eval (inc 'x))				; 1




;;▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇  宏的参数都是 Symbol / CONS-of-symbols  ------>  返回的也是  CONS-of-symbols
;;                                              (node)    (tree)                                (tree)
;;▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇ 宏就是对 tree-of-symbols ---> tree-of-symbols 的转换，并且转换过程中可以 eval部分tree-node





(defmacro inc-m (var)
  ;; (message "%s" (symbolp var))	 
  (print (symbolp var))			; T (var在里面确实是个symbol !)
  (list 'setq var (list '1+ var)))	; list of Symbols

;; 借助 `
(defmacro inc-ms (var)
  ;; ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇  特殊标记符 ▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇
  ;;    `   等于  map 'quote -->
  ;;    ,   等于  eval
  ;;    #'  等于  symbol-function
  ;;    ,@  类似  Ruby中的  #{ } 
  ;;    ',  等于  eval -> quote   (先把该子树计算一下、再引用结果树）----> 所以  `(.. ',s ..)  ===>  'r

  
  ;;  var本就是symbol，不应再次quote， 故在`(...)内部要手动eval一下（,-->去一层quote)
  `(setq ,var (1+ ,var)))		; list of Symbols    ('e  :: Symbol)


(inc-m y)				; 展开为    (SETQ Y (1+ Y))
(inc-ms y)				; 展开为    (SETQ Y (1+ Y))

  
;;************************************************************************************************
(defparameter b '(2 3))

`(1 ,@b 5)				;==>  (1 2 3 5)


;;
(defmacro exp-inc ()
  `(defmacro inc-exp (var)
     `(setq ,var (1+ ,var))))

(exp-inc)


;; 参数是一个数字 n ，我内部如何构造出一个 symbol :  inc-x  作为函数名？？

#|
(create-inc 5)

展开成为
(defun inc-5 (var)
  (setq var (+ 5 var)))

-------> 显然：我需要根据参数 symbol '5 ,  去构造一个 symbol 'inc-5
  'n ----symbol-name -> "n" ---> (concatenate "inc" "n") -> string inc-n -> read-from-string
|#

(read-from-string (concatenate 'string "inc-" (symbol-name 'var)))

(defmacro create-inc-n- (num)
  (let ((f-name (read-from-string (concatenate 'string "inc-" (symbol-name num)))))
    `(defmacro ,f-name (var)
	       `(setq ,var (+ ,',num ,var)))))

;;  成功了！
(defmacro create-inc-n (num)
  (let ((f-name (read-from-string (concatenate 'string "inc-" (write-to-string num)))))
    `(defun ,f-name (var)
       (setq var (+ ,num var)))))

(macroexpand-1 '(create-inc-n 13)) 	;==> (DEFUN INC-13 (VAR) (SETQ VAR (+ 13 VAR)))

	  
;; 这种函数是怎么声明的！ 第一个参数可指定、可不指定！
(concatenate 'string "abc" "d")	  
;;************************************************************************************************

#|
(create-inc-n++ y)

展开为

(defmacro inc-n (var)
    `(setq ,var (+ y ,var)))
|#
(defmacro create-inc-n++ (num)
    `(defmacro inc-n++ (var)
       `(setq ,var (+ ,',num ,var))))

(create-inc-n++ y)
;;  (DEFMACRO INC-N (VAR) `(SETQ ,VAR (+ ,'Y ,VAR)))
(defmacro inc-n++ (var)
  `(setq ,var (+ ,'y ,var)))

(inc-n++ 'x)				; (SETQ 'X (+ Y 'X))
