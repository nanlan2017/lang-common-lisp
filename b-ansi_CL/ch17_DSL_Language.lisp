;; 所有类都是用Map来模拟实现的。
;; 用一个map来代替一个object （ 就是 field-name  <---> field-value 嘛, 注意：成员函数也是其 field)

;; 访问obj的成员变量
(get 'color obj)
;; 调用obj的成员函数  (tell obj 'move 10)
(defun tell (obj target-method &rest args)
  (funcall (gethash target-method obj) args))

;; ---------------- 升级：支持继承的版本 -------------------
;; 继承： 无非是在 子类的obj中报错了一个 指向父类obj的指针
(defun rget (prop obj)
  (multiple-value-bind (val is-in) (gethash prop obj)
    (if is-in
	(values val is-in)
	;; 否则要递归去父类中寻找此prop
	;; obj这个map (正常key的类型为SYMBOL , 也有parent这个KEYWORD类型）
	(let ((parent (gethash :parent obj)))
	  (and parent
	       (rget prop parent))))))

(defun tell (obj target-method &rest args)
  (apply (rget target-method obj) args))

					;```````````````````````````````
;;  定义了两个instance，
;;  our-circle的 parent指向 cirle-class，  且 radius域放的2
(setf   circle-class                     (make-hash-table)
        our-circle                       (make-hash-table)
        (gethash :parent our-circle)     circle-class
        (gethash 'radius our-circle)     2)

;;  为circle-class注册一个 area()方法
(setf (gethash 'area circle-class)
        #'(lambda (x)			; 这个x 对应的是 ? 
            (* pi (expt (rget 'radius x) 2))))
					;```````````````````````````````
(tell our-circle 'area)

	   
        	  
