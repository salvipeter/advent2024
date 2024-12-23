(defparameter *connections*
  (let ((table (make-hash-table)))
    (loop for (a . b) in +data+ do
      (push b (gethash a table))
      (push a (gethash b table)))
    table)
  "A hash table mapping a computer to a list of connected computers.")

(defun starts-with-t-p (computer)
  (char= (char (symbol-name computer) 0) #\T))

(defun select (n list &optional acc)
  "Selects N elements from LIST."
  (cond ((= n 0) (list acc))
        ((null list) '())
        (t (append (select (1- n) (cdr list) (cons (car list) acc))
                   (select n (cdr list) acc)))))

(defun connectedp (list)
  (every (lambda (pair)
           (and (member (second pair) (gethash (first pair) *connections*))
                (member (first pair) (gethash (second pair) *connections*))))
         (select 2 list)))

(defun insert-and-sort (symbol list-of-lists)
  "Inserts SYMBOL into each list of LIST-OF-LISTS,
and sorts each sublist by symbol name."
  (mapcar (lambda (list)
            (sort (cons symbol (copy-list list)) #'string< :key #'symbol-name))
          list-of-lists))

(let ((triples (loop for k being the hash-key in *connections* using (hash-value v)
                     when (and (starts-with-t-p k) (>= (length v) 2))
                       append (insert-and-sort k (select 2 v)))))
  (format t "~a~%"
          (loop for tr in (delete-duplicates triples :test #'equal)
                count (connectedp tr))))

(loop named outer
      with max = (loop for v being the hash-value in *connections*
                       maximize (length v))
      for n from max downto 3           ; LAN of N + 1 computers
      when (< n (loop for v being the hash-value in *connections*
                      count (>= (length v) n)))
        do (loop for k being the hash-key in *connections* using (hash-value v)
                 when (>= (length v) n) do
                   (dolist (net (insert-and-sort k (select n v)))
                     (when (connectedp net)
                       (format t "~{~(~a~)~^,~}~%" net)
                       (return-from outer)))))
