(make-array)

;;;   尝试每种匹配   &optional --> &key ,  &rest
(defun my-make-array (dimensions
		      &rest args
		      &key
			(element-type t)
			initial-element)
  `(,dimensions ,args ,element-type ,initial-element))

(my-make-array)



(destructuring-bind (w (x y) . z) '(a (b c) d e)
    (list w x y z))			;-->   
