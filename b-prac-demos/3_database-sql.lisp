(defun sayhi ()
  (format t "Hello,Wang Jiaheng"))

(defun saybye ()
  (format t "Bye,Wang Jiaheng"))

;;; ---------------------  a music database demo ---------------------
;;; property-list
(getf (list :a 100 :b 23) :b)

;;; make-cd
(defun make-cd (title artist rating ripped)
  (list :title title :artist artist :rating rating :ripped ripped))

;;; global varible
(defvar *db* nil)

;;; add-record
(defun add-record (cd)
  (push cd *db*))

;;; dump-db
(defun dump-db ()
  (dolist (cd *db*)
    (format t "~{~a: ~10t~a~%~}~%" cd)))

;;; return a string
(defun prompt-read (prompt)
  (format *query-io* "~a: " prompt)
  (force-output *query-io*)
  (read-line *query-io*))

					; return : plist-cd
					;
(defun prompt-for-cd ()
  (make-cd
   (prompt-read "title")
   (prompt-read "artist")
   (or (parse-integer (prompt-read "rating") :junk-allowed t) 0)
					; t means True
					;(prompt-read "ripped [y/n]")))
   (y-or-n-p "ripped [y/n]: ")))

;;; whole
(defun add-cds ()
  (loop (add-record (prompt-for-cd))
     (if (not (y-or-n-p "Another?[y/n]: ")) (return))))

;;; ------------- save/load  data to/from  file-------------------------

(defun save-db (filename)
  (with-open-file (out filename
		       :direction :output
		       :if-exists :supersede)
    (with-standard-io-syntax
      (print *db* out))))
;; <test>  (save-db "./workspace/db.txt")

(defun load-db (filename)
  (with-open-file (in filename)
    (with-standard-io-syntax
      (setf *db* (read in)))))


;;;------------------ filter, lambda -----------------------------
;;; filter ===  get even  numbers
					; #'    "following is a function!"
					; '  
(remove-if-not #'evenp '(1 2 3 4 5 6 7 8 9))
					; even's  lambda:   \x -> (mod x 2)==0
(remove-if-not #'(lambda (x) (= 0 (mod x 2))) '(1 2 3 4 5 6 7 9))
					; filter data : artist is "love"
(remove-if-not #'(lambda (cd) (equal (getf cd :artist) "love")) *db*)

;;;
(defun select-by-artist (artist)
  (remove-if-not
    #'(lambda (cd) (equal (getf cd :artist) artist))
    *db*))

(defun select (selector val)
  (remove-if-not
   #'(lambda (cd) (equal (getf cd selector) val))
   *db*))
;;@@@ <test>
(select :artist "love")
(select :rating 1)

;;;-------------- high-order function ------------------------
;;; require predict(function) as parameter
(defun select-with (predict)
					;(remove-if-not #'predict *db*))
  (remove-if-not predict *db*))


;;; return a predict (function)
(defun artist-selector (artist)
  #'(lambda (cd) (equal (getf cd :artist) artist)))

;;;--------------- keyword parameter-------------------
(defun where (&key title artist rating (ripped nil ripped-p))
  #'(lambda (cd)
      (and
       (if title (equal (getf cd :title) title) t)  ; if # then # else #  --- 3 items
       (if artist (equal (getf cd :artist) artist) t)
       (if rating (equal (getf cd :rating) rating) t)
       (if ripped-p (equal (getf cd :ripped) ripped) t))))
       
;;> > > > > > >>>>>> >>>>> >>>>>>>> >>>>>>>>>>>>>>   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
(defun update (selector-fn &key title artist rating (ripped nil ripped-p))
  (setf *db*
        (mapcar 
         #'(lambda (row) 		; map to each row of *db* : (when matched--> set value)
             (when (funcall selector-fn row)
               (if title    (setf (getf row :title) title))
               (if artist   (setf (getf row :artist) artist))
               (if rating   (setf (getf row :rating) rating))
               (if ripped-p (setf (getf row :ripped) ripped)))
             row) *db*)))

(defun delete-rows (selector-fn)
  (setf *db* (remove-if selector-fn *db*)))

;;;################################## Macro: extract common symbols ##############################
;;; target <<<<<
(make-comp-exp :rating 3)    ;==> (equal (getf cd :rating) 3)

(defun make-comp-exp (field value)
  (list 'equal (list 'getf 'cd field) value))

;;; test `
`(1 2 (+ 1 2)) 				; (1 2 (+ 1 2))
`(1 2 ,(+ 1 2))				; (1 2 3)
'(1 2 (+ 1 2))			; (1 2 (+ 1 2))  ; ' prevent following s-exp(atom| (...) from been evaluated
'(1 2 (+ 1 2))			; (1 2 3)

;;;
(defun make-comp-list (fields)
  (loop while fields
     collecting (make-comp-exp (pop fields) (pop fields))))

;; test
;;(make-comp-list

(defmacro where2 (&rest clauses)
  `#'(lambda (cd) (and ,@(make-comp-list clauses))))

					; -------- test ( -------------
(macroexpand-1 '(where2 :title "myt" :rating 4))
(select (where2 :title "myt" :rating 4)) ; done !!!!
					; -------- ) test ------------
					
















   




