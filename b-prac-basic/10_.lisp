(make-array 5 :initial-element nil)


;; count
(count 1 #(1 3 5 1 6 8))
;; remove
(remove 1 #(1 3 5))
;; substitute
(substitute 9 1 '(1 3 5 1 3 5))
;; find
(find 1 '(3 5 1 4 6 7 1 2)) 		; return target-val if exists
;; position
(position 1 '(3 5 2 1 3 1))



(defparameter *h* (make-hash-table))
(gethash 'foo *h*) 			; 2 returns
(setf (gethash 'foo *h*) 'quux)
(gethash 'foo *h*)


;;; Multiple-value-bind (a b) (1 2)  ====>  a = 1 , b = 2     ( ~ let)
(defun show-value (key table)
  (multiple-value-bind (val is-exist) (gethash key table)
    (if is-exist
	(format t "~a ; exists~%" val)
	(format t "~a ; x !~%" val))))

(setf (gethash 'k1 *h*) nil)
(setf (gethash 'k2 *h*) 2)

(show-value 'k1 *h*)
(show-value 'k2 *h*)
(show-value 'k3 *h*)

;;***********************************************
(defparameter *set* ())
(adjoin 1 *set*)   			; adjoin  :  const




