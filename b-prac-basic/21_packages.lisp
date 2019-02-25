;; 当前包
*package*

;; 3个系统包：common-lisp(cl),  common-lisp-user(cl-user),  keyword
;; ?  cl-user从哪些包中继承了symbols
(mapcar #'package-name (package-use-list :cl-user))
;; ？ 一个符号最初来源于哪个包
(package-name (symbol-package 'defun))
;; ？ 
