
;;  如果只是用 handler-case的话，那就和Java的 try-throw-catch是一样的
;;  其弊端时： 异常发生时，会从发生异常的函数栈返回上层调用、丢失现场！

;;                 Java
;; try {
;;    doStuff();
;;    doMoreStuff();
;; } catch (SomeException se) {
;;    recover(se);
;; }

;;                 Lisp (▇▇▇▇ handler-case)
(handler-case
    (progn
      (doStuff)
      (doMoreStuff))
  (some-exception (se) (recover se)))


;;------------------------------------
;;▇▇▇▇ handler-bind
(defun log-analyzer ()
  (handler-bind ( ;; bindings
		  ;; 此处用了一个lambda 作为 restart-function （前提：底层抛出处提供 'skip..这个restart)
		 (malformed-log-entry-error #'(lambda (c) (invoke-restart 'skip-log-entry))))
    ;; forms
    (dolist (log (find-all-logs))
      (analyze-log log))))

;; 优化套路：将此lambda 设计成一个同restart名的函数
(defun skip-log-entry (c)
  (invoke-restart 'skip-log-entry))
;; --->  上面的 log-analyzer()就可以写 (malformed-log-entry-error #'skip-log-entry) 了


;;********************* restart *****************************
;;*********************  极佳    *****************************
;;*********************  Demo   *****************************
;; log-analyzer-*
;;    -->  analyze-log
;;        -->  parse-log-file
;;            --> parse-log-entry  ; 可能抛出异常
(define-condition malformed-log-entry-error (error)  
  ((test :initarg :text :reader text)))  
  
(defun parse-log-entry (text)  
  (if (evenp text)  ;;  只有偶数才可以正常parse，否则抛出一个“状况"instance
      (list text "even")  
      (error 'malformed-log-entry-error :text text)))  
  
(defun parse-log-file ()  
  (loop for i from 1 to 10  
     for entry = (restart-case (parse-log-entry i);;提供三个"restart" (供上层指定的restart-function来回调）
      (skip-it (h) h)			  ;  底层“排列”了数个可用的Restart-case
      (use-value (v) (list v "odd"))		  ;  上层来安排选用哪种restart策略 （此时底层栈restart，重启继续执行）
      (reparse-it (fixed-text) (parse-log-entry fixed-text)))  
     when entry collect it))  		          ;  每个Restart-case必须提供一个和正常结果同类型的值！
  
  
;; 3个Restart-function （具体的重启操作）———— 底层发生出、上层指定处，都只是指定、而非定义重启操作逻辑
;;     上层： 指定该异常时的 Restart-Function :  (以下3个之一）
;;     Restart-Function :  invoke(回调)一个 restart-case
;;
;;  -------------  按回调理解
;;      底层异常发生处：产生一个Condition类实例
;;          此时要给它指定一个“Restart-function"（通过回调调用）
;;   ▇▇▇▇     —— 此function能产生一个与正常值类似的值（才好接着跑）
;;   ▇▇▇▇ 处理逻辑分散在 ”restart-function(exception) 和 restart中！
;;   ▇▇▇▇ 一个restart-function(exception) 需要invoke一个restart （上面的 v, fixed-text就是由此invoke提供！）
(defun skip-log-entry (c)  
  (let ((restart (find-restart 'skip-it)))  
    (when restart  
      (invoke-restart restart "haha"))))  

;; 特殊：use-value这个restart由库提供
(defun use-value-p (c)
  ;; " Transfer control and VALUE to a restart named USE-VALUE, or return NIL if none exists."
  (use-value (text c)))  		; use-value由库提供，它只是从exception-instance中取出一个值给invoke的case
  
(defun reparse-log-entry (c)  
  (let ((reparse (find-restart 'reparse-it)))  
    (when reparse  
      (invoke-restart reparse (+ (text c) 11))))) ;===>   "fixed-text" == (getText c)+11

;;-----------------------------------------------------------------
(defun analyze-log ()  
  (print (parse-log-file)))
  
;;在高层函数中，根据不同的情况选择不同的再启动策略  
(defun log-analyzer-skip ()  
  (handler-bind ((malformed-log-entry-error #'skip-log-entry))  ; 底层可以继续运行的！
    (analyze-log)))
;;==> ("haha" (2 "even") "haha" (4 "even") "haha" (6 "even") "haha" (8 "even") "haha"
;;     (10 "even")) 
  
(defun log-analyzer-use ()  
  (handler-bind ((malformed-log-entry-error #'use-value-p))  
    (analyze-log)))
;;==>  
;; ((1 "odd") (2 "even") (3 "odd") (4 "even") (5 "odd") (6 "even") (7 "odd")
;;  (8 "even") (9 "odd") (10 "even"))

  
(defun log-analyzer-reparse ()  
  (handler-bind ((malformed-log-entry-error #'reparse-log-entry))  
    (analyze-log)))
;;==> ((12 "even") (2 "even") (14 "even") (4 "even") (16 "even") (6 "even")
;;     (18 "even") (8 "even") (20 "even") (10 "even")) 

		 


