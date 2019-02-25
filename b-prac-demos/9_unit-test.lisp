(defun report-result (result s-form)
  (format t "~:[FAIL~;pass~] ... ~a~%" result s-form))

			        
(report-result (= (+ 1 2) 3) '(= (+ 1 2) 3))

				        
(check (= (+ 1 2) 3))
;; ===>  (report-result (= (+ 1 2) 3) '(= (+ 1 2) 3))

(defmacro check (sexp)
  `(report-result ,sexp ',sexp))	;▇▇▇     ',form  in `(...)    ====>   'form  in EXPANSION


;;test "+"
(defun test-+ ()
  (check (= (+ 1 2) 3))
  (check (= (+ 4 5) 9))
  (check (= (+ 1 7) 4)))		; ! duplicate "check"

;;
(defmacro check-s (&rest forms)
  `(progn
     ,@(loop for f in forms collect `(report-result ,f ',f))))

;; =====>
(defun test-+ ()
  (check-s
   (= (+ 1 2) 3)
   (= (+ 4 5) 9)
   (= (+ 1 7) 4)))

;; ----> 
(PROGN
 (REPORT-RESULT (= (+ 1 2) 3) '(= (+ 1 2) 3))
 (REPORT-RESULT (= (+ 4 5) 9) '(= (+ 4 5) 9))
 (REPORT-RESULT (= (+ 1 7) 4) '(= (+ 1 7) 4)))


  
  
