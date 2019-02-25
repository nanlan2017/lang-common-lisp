;;;     bank-accout.Class
;;;  checking-..  |    saving-..

(defgeneric withdraw (account amount)
  (:documentation "Withdraw the specified amount from the account.
Signal an error if the current balance is less than amount"))

;; "bank-account".withdraw(amount)
(defmethod withdraw ((account bank-accout) amount)
  (when (< (balance account) amount)
    (error "Account overdrawn!"))
  (decf (balance account) amount))

;; "checking-account".withdraw(amount)
;; function-> overdraft-account ::  get the associated bank-account of a checking-account
(defmethod withdraw ((account checking-account) amount)
  (let ((overdraft amount (balance checking-account)))
    (when (plusp overdraft)		; withdraw > banlance
      (withdraw (overdraft-account account) overdraft)
      (incf (balance account) overdraft))) ; ?
  ;; super.withdraw(amount)   ==== withdraw (checking-account::BANK-ACCOUNT , amount)
  (call-next-method))


;;;-----------------Ruby: singleton method -------------------
;; Ruby : singleton-method (for specified instance /not Class)
;; (defparameter *value* "haha")
;; (defmethod change (content (eql *value*))
;;   (print content))
;; (change *value*)
;; (setf *value* "hiahia")
;; (change *value*)

;;;------------------ AOP -----------------------------------
(defmethod withdraw :before ((account checking-account) amount)
  "...stuff will  be executed before |checking-account|.withdraw() ")

;;******************************************************
;; 1.  generic function : 1st parmeter will be  the (instance-name class-id)
;;******************************************************


(defclass bank-account ()
 (customer-name
  balance))

(defclass checking-account (bank-account)
  )

(defclass saving-account (bank-account)
  )
					;||||||||||||||||||||||||||
;; SLOT-VALUE /  SETF
(defparameter *ba* (make-instance 'bank-account))
(setf (slot-value *ba* 'customer-name) "wangjiaheng")
(slot-value *ba* 'customer-name)
					;-------------------------

(defparameter *instance-count* 0)

(defclass bank-account ()
  ((customer-name
    :initarg :name
    :initform (error "Must supply name of customer") ; trigged if not provided when 'make-instance
    :accessor customer-name
    :documentation "Customer's name")
   (balance
    :initarg :balance
    :initform 0
    :reader balance)
   (account-number
    :initform (incf *instance-count*))))

;; INITIALIZE-INSTANCE
(defmethod initialize-instance :after ((account bank-account)
				       &key opening-bonus-percentage)
  (when opening-bonus-percentage
    (incf (slot-value account 'balance)
	  (* (slot-value account 'balance) (/ opening-bonus-percentage 100)))))


;; MAKE-INSTANCE
(defparameter *acc* (make-instance
		     'bank-account
		     :name "wjh"
		     :balance 200
		     :opening-bonus-percentage 5))

;; REMOVE-METHOD  /  FIND-METHOD
(remove-method #'initialize-instance
	       (find-method #'initialize-instance () (list (find-class 'bank-account))))

					;````````````````````````````````
(customer-name *acc*)
(setf (customer-name *acc*) "wjh-new")

;; slot-value/  setf   are still  useful
(slot-value *acc* 'customer-name)
(setf (slot-value *acc* 'customer-name) "wangjiaheng")
  





      



