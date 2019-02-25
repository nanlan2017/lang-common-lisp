(defpackage com.jh.spam
  (:use :common-lisp
	:com.jh.pathnames))

;;;------------------------------------------------------
(in-package :com.jh.spam)
;;;------------------------------------------------------
;;; main函数
;;;    从email的text提取features ---> 计算出一个score ---> 据此将其分类
(defun classify (email-text)
  (classification (score (extract-features email-text))))

;;; 最简单的：根据score进行分类
(defparameter *max-ham-score* 0.4)
(defparameter *min-spam-score* 0.6)

(defun classification (score)
  ;; switch-case用COND
  (cond
    ((<= score *max-ham-score*) 'ham)	; ? 这是什么类型
    ((>= score *min-spam-score*) 'spam)
    (T 'unsure)))

;;; 邮件文本中的每个独立单词会被分析成为一个word-feature实例
;;; 对于每个单词，需跟踪它在垃圾邮件(spam)中出现的次数、在正常邮件中出现的次数(ham)
(defclass word-feature ()		; 无父类
  ;; slots
  ;; 具体的设置会影响建立、访问一个instance时的方式
  ((word :initarg :word
	 :accessor word
	 :initform (error "Must supply word text")             ; 初始化时若未指定该字段时将求值 :initform（可用作初始值、报错）
	 :documentation "The word this feature represents")
   (spam-count :initarg :spam-count
	       :accessor spam-count
	       :initform 0
	       :documentation "...")
   (ham-count :initarg :ham-count
	      :accessor ham-count
	      :initform 0
	      :documentation "...")))

;;; 用hashmap保存
;; defvar : 则二次加载该变量时数据不会被重置
;; [等价Java]   Map *f-d* = new Map(:test=#'equal);
(defvar *features-database* (make-hash-table :test #'equal))    ; 指定key判重的策略是equal,而非默认的eql

(defun clear-database ()
  (setf *features-database* (make-hash-table :test #'equal)))   ;

;;; 根据word查找其在database中的word-feature对象
;; :: String -> Word-feature
(defun intern-feature (word)
  (or (gethash word *features-database*)
       (setf (gethash word *features-database*)
	     (make-instance 'word-feature :word word))))

;;; 使用CL-PPCRE-正则表达式库，来从邮件文本中导出所有不重复的单词
;; 单词： 长度>=3的英文字符
;; RET : list of words(String)
(defun extract-words (text)
  (delete-duplicates
   (cl-ppcre:all-matches-as-strings "[a-zA-Z]{3,}" text)
   :test #'string=))

;; RET : list of Word-feature
(defun extract-features (text)
  (mapcar #'intern-feature (extract-words text)))

;; 特化print-object这个多态方法
;; 默认的一个word-feature对象打印：   #<WORD-FEATURE @ #xffffffff> (即object-type + object-identity)
;; 美观打印： 
(defmethod print-object ((object word-feature) stream)
  ;;
  (print-unreadable-object (object stream :type t)
    (with-slots (word ham-count spam-count) object
      (format stream "~s :hams ~d :spams ~d" word ham-count spam-count))))
  
;;----------------- 			 

(defun train (text type)
  (dolist (feature (extract-features text))
    (increment-count feature type))
  (increment-total-count type))


(defun increment-count (feature type)
  (ecase type
    (ham (incf (ham-count feature)))
    (spam (incf (spam-count feature)))))
      


   
  









