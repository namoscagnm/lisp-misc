(defstruct fifo
  (aslist nil :type list)
  (end nil :type list)
  )


(defmethod enqueue ((q fifo) newkey &optional fn-on-newkeysource) 
  (if (null (fifo-aslist q))
      (progn (setf (fifo-aslist q) (cons nil nil))
	     (setf (first (fifo-aslist q)) newkey)
	     (setf (fifo-end q) (last (fifo-aslist q)))
	     )
      (let* ((toadd (cons newkey nil)) (newend (last toadd)))
	(setf (rest (fifo-end q)) toadd)
	(setf (fifo-end q) newend)
	)
      )
  (when fn-on-newkeysource (funcall fn-on-newkeysource newkey))
  )

(defmethod enqueue ((q fifo) (input-list list) &optional fn-on-newkeysource)
    (mapcar (lambda (x) (enqueue q x fn-on-newkeysource)) input-list)
    )

(defmethod dequeue ((q fifo))
  (let ((result (pop (fifo-aslist q))))
    (if (null (first (fifo-aslist q)))
	(setf (fifo-end q) nil))
    result)  
  )
