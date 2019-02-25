;; do-until
(do ((i 1 (1+ i)))
    ((> i 10) 'sexp-1 'done)
  (format t "~A ~A ~%" i (* i i)))

(function +)

#'+

;;***************************************************
;;  2. 给出3种不同的 (a b c)的cons写法
(cons 'a (cons 'b 'c))
(cons (cons 'a 'b) 'c)
(cons (cons 'a  nil) (cons 'b 'c))


;;  x is not null +   head x is null or
;;  check : 列表中是否存在nil元素（不是最后一个元素）
(defun enigma (x)
  (and (not (null x))
       (or  (null (car x))
	    (enigma (cdr x)))))

(enigma '(1 2 nil 3))
(enigma '(1 2 3 4))

;; find : 首次出现的下标--nil表示没有，否则返回第一次的下标
(defun mystery (x y)
      (if (null y)
          nil
          (if (eql (car y) x)
              0
              (let ((z (mystery x (cdr y))))
                (and z (+ z 1))))))


(mystery '1 '(2 3 2 3 1 2 3))

(and 3 4)
(and 4 3)
(and nil 3)

;;**************************************************
(alias + ad)
;; ===>
(defun ad (&rest args) 
  (+ args))

(defun ad-2 (&rest args)
  (if (type-of 

(defvar 

(defmacro alias (f-oldname f-newname)
  `(defun ,f-newname (&rest args)
     (,f-oldname args)))


(ad 1 2)))))
;;**************************************************
(defun is-contain-list (lst)
  (some #'listp lst))

(defun is-contain-list-v2 (lst)
  (if (null lst)
      nil
      (if (listp (car lst))
	  T
	  (is-contain-list-v2 (cdr lst)))))

(defun is-contain-list-v3 (lst)
  (dolist (elem lst)
    (if (listp elem)
	(return t)
	nil)))


(is-contain-list '(1 (2 3) 4))
(is-contain-list '(1 2 3 4))

(is-contain-list-v2 '(1 (2 3) 4))
(is-contain-list-v2 '(1 2 3 4))

(is-contain-list-v3 '(1 (2 3) 4))
(is-contain-list-v3 '(1 2 3 4))


(defun summit (lst)
      (remove nil lst)
      (apply #'+ lst))

(summit '(nil 1 nil 2 3))
(summit-v2 '(nil 1 nil 2 3))

(defun summit-v2 (lst)  
  (apply #'+ (remove nil lst)))


(defun summit (lst)
      (let ((x (car lst)))
        (if (null x)
            (summit (cdr lst))		; 不管x是否Null，都会继续向下一层递归！ 即： 缺少递归终止条件
            (+ x (summit (cdr lst))))))

(defun summit (lst)
      (let ((x (car lst)))
        (if (null x)
            (if (null lst)
		0
		(summit (cdr lst)))
            (+ x (summit (cdr lst))))))


