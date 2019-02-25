;;; ---------------  quote == ' --------------------
;; keep the list as list, don't evaluate
(quote 6)
'6
'(+ 1 2) ; (+ 1 2)

;;; ---------------- atom== is_atom? --------------
;; true==T  : if x is atom OR  empty list ()
;; nil==() : else
(atom '3) ; T
(atom (+ 1 2)) ;T
(atom '(+ 1 2)) ; nil

;;;------------------- eq ------------------------
;; true : if x,y is same atom  OR both empty list ()
;; nil  : else
(eq '3 3) ; T
(eq () ()) ; T
(eq 3 (+ 1 2)) ;T
(eq 3 '(+  1 2)); nil

;;;----------- cond== conditional value ------------
;; chain-if-compare
(cond ((eq 'a 'b) '1)
        ((atom 'a)  '(+ 1 1))) ; (+ 1 1)







;;;------------------ car == head ---------------
(car '(+ 1 2)) ; +
(car '1) ;; error! must follow a List (use quote to avoid being evaluated to atom value)

;;;------------------ cdr == tail ---------------
(cdr '(+ 1 2)) ; (1 2)


;;;------- cons == : (add item to list front)------
(cons 1 '(2 3)) ; (1 2 3)


;;;*************************************************************************
					; (lambda (args) (body)))
					; (f arg-1 arg-2)
((lambda (x li) (cons x (cdr li)))
 '1
 '(3 2 1))  ; (1 2 1)

;; high-order : function as a parameter
((lambda (f) (f '(2 3)))
 '(lambda (li) (cons '1 li)))    ; ????

;;;------------- recursion -----------------
					; substitute y -> x in S-expression z
					; if (z is atom)  then return x | z
					; else return (subst head):(subst tail)
;; using lambda to define recursive-function
(label subst (lambda (x y z) 
	       (cond
		 ((atom z) (cond ((eq y z) x)
				 ('t z)))
		 ('t (cons (subst x y (car z)) (subst x y (cdr z)))))))

;; == defun subst (x y z) ...
(defun subst2 (x y z)
  (cond ((atom z)
          (cond ((eq z y) x)
               ('t z)))
        ('t (cons (subst2 x y (car z))
                  (subst2 x y (cdr z))))))

;; ###test
(subst '1 '9 '(9 7 9))  ; (1 7 1)
(subst2 '1 '9 '(9 7 9)) ; (1 7 1)
;; cond (con-1 ret-1) ('t ret-2)   === if con-1 then ret-1 else ret-2

;;;****************************************************************************************
;;; null?
(defun null. (x)
  (eq x '()))

;;; AND
;; if x=true
;;    if y=true then TRUE
;;    else FALSE
;; else FALSE
(defun and. (x y)
  (cond (x (cond (y 't)
		 ('t '())))
        ('t '() )))

;;; NOT
(defun not. (x)
  (cond (x '())
        ('t 't)))

;; append ===  (head li-1) : (append (tail li-1) li-2)
(defun append. (x y)
   (cond ((null. x) y)
         ('t (cons (car x) (append. (cdr x) y)))))

;; zip
(defun pair. (xs ys)
  (cond (
	 (and. (null. xs) (null. ys)) ;; con-1
	 '()
	 ) ;; v-1
	(
	 't
	 (cons
	   (list (car xs) (car ys))
  	   (pair. (cdr xs) (cdr ys)))
	 )
  ))
    
;;### test
(pair. '(1 2 3) '("a" "b" "c"))


;; lookup (map)
(defun assoc. (x y)
  (cond (
	 (eq (caar y) x)
	 (cadar y)
	)
        (
	 't
	 (assoc. x (cdr y))
	)
   ))

;;###test
(assoc. 'x '((x new) (x a) (y b)))

;;;********************************************************


