(defun test-system ()
  #+sbcl (format t "This is SBCL.~%")
  #+clisp (format t "This is Clisp.~%")
  #-(or sbcl clisp) (format t "Don't know"))

(directory
