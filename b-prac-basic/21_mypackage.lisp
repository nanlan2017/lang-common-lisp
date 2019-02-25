(defpackage :com.jiaheng.text-db
  (:use :common-lisp)
  (:export :open-db
	   :save
	   :store))

;; 先声明了一个package    __import了text-db这个module(package))
(defpackage :com.jiaheng.email-db
  (:use :common-lisp
	:com.jiaheng.text-db)
  (:import-from :com.acme.email	:parse-email-address
		
		)

;; 进入package环境—— 其后的符号的上下文都位于该环境，直到通过in-package再次切换
(in-package :com.jiaheng.email-db)

(defun hello-world ()
  (format t  "hello, from :com.jiaheng.email-db"))

;; 切换回cl包环境
(in-package :cl)

;; 在REPL中输入  包名:: --> TAB  可一览该包中的symbols(含从其他包中导入的symbols)



