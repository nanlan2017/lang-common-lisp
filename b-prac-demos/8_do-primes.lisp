;; ------------ Helper ----------------------
;; Helper function 1  : check a num whether a prime
;; Type :  Bool
(defun primep (n)
  ;; can't be mod to 0 by (2-- sqrt(n))
  (when (> n 1)
    (loop for fac from 2 to (isqrt n)
       never (zerop (mod n fac)))))


;; Helper function 2 : get next prime
(defun next-prime (n)
  ;; return n if n is prime
  (loop for i from n
     when (primep i) return i))

					; ++++++++++++++ usecase ++++++++++++++++++++++++++
;; @ client using case (target)
(do-primes (p 0 19)
  (format t "~d~%" p))

;; @ equivlent expansion
(do ((p (next-prime 0) (next-prime (1+ p))))
    ((> p 19))
  (format t "~d~%" p))

;;----------- implemention -------------------------------------------------------------------
;;  X X X (no compiling)
;; (defmacro do-primes ((p start end) (body-exp)) ; x  no pattern matching !
;;   `(do ((p (next-prime start) (next-prime (1+ p))))
;;        ((> p end))
;;      (body-exp)))
					; let  var   = first exp
					;      start = second exp
					;      end   = third exp
(defmacro do-primes (value-range-exp &rest body)
  (let ((var (first value-range-exp))
	(start (second value-range-exp))
	(end (third value-range-exp)))
					; in
    ;; , :  on varibles that reprensents a value (should be evaluated after expansion)
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var))))
	 ((> ,var ,end))
       ,@body)))

;;------------ verify -----------------
					; +++++++++++++++++ test( +++++++++++++++++++++++
(macroexpand-1 '(do-primes (p 0 19) (format t "~d~%" p)))
(macroexpand-1 '(do-primes! (p 0 19) (format t "~d~%" p)))
(macroexpand-1 '(do-primes-x (p 0 19) (format t "~d~%" p)))
(macroexpand-1 '(do-primes-s (p 0 19) (format t "~d~%" p)))
(macroexpand-1 '(do-primes-ss (p 0 19) (format t "~d~%" p)))
	 
(defmacro do-primes! ((var start end) &body body)
  `(do  ((,var (next-prime ,start) (next-prime (1+ ,var))))
        ((> ,var ,end))
     ,@body))

;; without ` notation
(defmacro do-primes-x ((var start end) &body body)
  (append '(do)
	  ;; ((
	  ;; ,var
	  ;; (next-prime ,start)
	  ;; (next-prime (1+ ,var))
	  ;; ))
	  (list (list (list var
			    (list 'next-prime start)
			    (list 'next-prime (list '1+ var)))))
	  ;; ((> ,var ,end))     === [ [ (a , b ,c ) ] ] === 3 levels
	  (list (list (list '>var end)))
	  body))

;; //TODO
;; define a macro : can dispatch to the above 3 different do-prime implementions


;;---------------- leak -----------------
;; 1. ensure s-exp params to be evaluated only 1 time
;;      and :   the evaluate sequences are same with param sequence
;; 2. ensure symbol conflicts when calling this macro
(defmacro do-primes-s ((var start end) &body body)
  (let ((end-val-id (gensym))) 	        ; generate a unique id for 'symbols in expanded code'
    ;; var = start
    ;; do {
    ;;      |... f (var )....|
    ;;      var = next           //  var start (next var)
    ;; } while { end-form }
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
	  ;; ensure 1 time only 
	  (,end-val-id ,end))
	 ;; WHILE condition
	 ((> ,var ,end-val-id))
       ,@body)))


;;********************************************************************************8
;;;   extract "let (id1 gensym)  (id2 gensym)"  ====>   with-gensym (id1 id2)
(defmacro with-gensyms ((&rest names) &body body)
  ;; ===>  loop for n in names collect (n, (gensym))  ===> ((a #:g1) (b #:g2))
  ;; let ((a #:g1) (b #:g2))  body
  `(let ,(loop for n in names collect `(,n (gensym))) ;▇▇▇▇▇▇▇▇▇▇ loop expand --> with-gensyms expand -->  do-primes expand
     ,@body))

					;|||||||||||||||||||||||| test ( |||||||||||||||||||||||
;; test-case : with-gensyms
(defmacro do-primes-ss ((var start end) &body body)
  (with-gensyms (end-val-id)
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
	  (,end-val-id ,end))
	 ;; while
	 ((> ,var ,end-val-id))
       ,@body)))


(defmacro do-primes-sss ((var start end) &body body)
  (with-gensyms (end-val-id)
    `(do ((,var (next-prime ,start) (next-prime (1+ ,var)))
	  (,end-val-id ,end))
	 ;; while
	 ((> ,var ,end-val-id))
	 ,@body)))

(((((((((((((((())))))))))))))))
((+ 1 2))

     
(define traverse lambda
    lambda ())
