(defclass speaker () ())

;; Speaker#speak(string)
(defmethod speak ((s speaker) string)
  (format t "~A" string))

					; `````````````````
(speak (make-instance 'speaker) "FATHER说")

;; 子类
(defclass intellectual (speaker) ())

(defmethod speak :before ((i intellectual) string)
  (princ "son-before "))

(defmethod speak :after ((i intellectual) string)
  (princ "son-after"))

;;  speaker的 speak-- befor
(defmethod speak :before ((s speaker) string)
  (princ "father-before "))

(defmethod speak :after ((s speaker) string)
  (princ "father-after "))

					;``````````````````
(speak (make-instance 'intellectual) " SON说 ") ; son-before father-before  SON说 father-after son-after


;; ------ :around -------------
(defclass courtier (speaker) ())

(defmethod speak :around ((c courtier) string)
  (format t "~A~%" "son-around-first")
  (if (eql (read) 'yes)
      (if (next-method-p) (call-next-method)) ; 在内部使用call-next-method来操作调用其拦截的主方法(用同样的参数)
      ;; 非yes时才走到这
      (format t "..."))
  'bow)
					;```````````````````
(speak (make-instance 'courtier) "[  ]")

;;▇▇▇▇▇▇▇▇▇▇  无论是哪个 :before 或 :after 方法被调用，整个通用函数所返回的值，是最具体主方法的返回值 
;;▇▇▇▇▇▇▇▇▇▇ 记得由 :around 方法所返回的值即通用函数的返回值，这与 :before 与 :after 方法的返回值不一样。
;;**************************** 方法组合机制 ************************************************
;;▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇▇  generic function 就像Java中的Interface一样！！
(defgeneric price (x)
  (:method-combination +))

(defclass jacket () ())
(defclass trousers () ())
(defclass suit (jacket trousers) ())

;; Jacket#price()--> 350
(defmethod price + ((jk jacket)) 350)
;; Trousers#price() --> 200
(defmethod price + ((tr trousers)) 200)
					;```````````````````````````
(price (make-instance 'suit))

