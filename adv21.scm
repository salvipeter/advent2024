;;; List utilities

(define (butlast lst)
  (if (null? (cdr lst))
      '()
      (cons (car lst) (butlast (cdr lst)))))

(define (remove x lst)
  (cond ((null? lst) '())
        ((eq? (car lst) x) (cdr lst))
        (else (cons (car lst) (remove x (cdr lst))))))

;;; Basic functions for keypad navigation

(define (code-chars code)
  (string->list (symbol->string code)))

(define (code-value code)
  (string->number (substring (symbol->string code) 0 3)))

(define (step pos dir)
  (case dir
    ((l) (cons (- (car pos) 1) (cdr pos)))
    ((r) (cons (+ (car pos) 1) (cdr pos)))
    ((u) (cons (car pos) (- (cdr pos) 1)))
    ((d) (cons (car pos) (+ (cdr pos) 1)))
    ((a) pos)))

(define (numeric-pos c)
  (cdr (assoc c '((#\0 . (1 . 3))
                  (#\A . (2 . 3))
                  (#\1 . (0 . 2))
                  (#\2 . (1 . 2))
                  (#\3 . (2 . 2))
                  (#\4 . (0 . 1))
                  (#\5 . (1 . 1))
                  (#\6 . (2 . 1))
                  (#\7 . (0 . 0))
                  (#\8 . (1 . 0))
                  (#\9 . (2 . 0))))))

(define (numeric-valid? pos dirs)
  (or (null? dirs)
      (let ((p (step pos (car dirs))))
        (and (>= (car p) 0) (< (car p) 3)
             (>= (cdr p) 0) (< (cdr p) 4)
             (not (equal? p '(0 . 3)))
             (numeric-valid? p (cdr dirs))))))

(define (direction-pos d)
  (cdr (assoc d '((l . (0 . 1))
                  (d . (1 . 1))
                  (r . (2 . 1))
                  (u . (1 . 0))
                  (a . (2 . 0))))))

(define (direction-valid? pos dirs)
  (or (null? dirs)
      (let ((p (step pos (car dirs))))
        (and (>= (car p) 0) (< (car p) 3)
             (>= (cdr p) 0) (< (cdr p) 2)
             (not (equal? p '(0 . 0)))
             (direction-valid? p (cdr dirs))))))

(define (move-list from to)
  (let ((dx (- (car to) (car from)))
        (dy (- (cdr to) (cdr from))))
    (append (vector->list (make-vector (abs dx) (if (< dx 0) 'l 'r)))
            (vector->list (make-vector (abs dy) (if (< dy 0) 'u 'd))))))

(define (valid-permutations pos dirs pred)
  (let ((result '()))
    (letrec ((rec (lambda (dirs acc)
                    (if (null? dirs)
                        (when (pred pos (reverse acc))
                          (set! result (cons (reverse (cons 'a acc)) result)))
                        (for-each (lambda (d)
                                    (when (member d dirs)
                                      (rec (remove d dirs) (cons d acc))))
                                  '(l r d u))))))
      (rec dirs '()))
    result))

;;; Shortest sequence search

(define cache '())
(define (dir-seq-length relays)
  (lambda (from to)
    (let ((cached (assoc (list relays from to) cache)))
      (if cached
          (cdr cached)
          (let* ((p0 (direction-pos from))
                 (p1 (direction-pos to))
                 (seqs (valid-permutations p0 (move-list p0 p1) direction-valid?))
                 (result (if (= relays 1)
                             (apply min (map length seqs))
                             (apply min
                                    (map (lambda (seq)
                                           (apply + (map (dir-seq-length (- relays 1))
                                                          (cons 'a (butlast seq)) seq)))
                                         seqs)))))
            (set! cache (cons (cons (list relays from to) result) cache))
            result)))))

(define (num-seq-length relays)
  (lambda (from to)
    (let ((p0 (numeric-pos from))
          (p1 (numeric-pos to)))
      (apply min
             (map (lambda (seq)
                    (apply + (map (dir-seq-length relays)
                                   (cons 'a (butlast seq)) seq)))
                  (valid-permutations p0 (move-list p0 p1) numeric-valid?))))))

(define (min-seq-length relays code)
  (let ((chars (code-chars code)))
    (apply + (map (num-seq-length relays)
                  (cons #\A (butlast chars)) chars))))

(define (complexity relays)
  (lambda (code)
    (* (min-seq-length relays code) (code-value code))))

(display (apply + (map (complexity 2) data)))
(newline)
(display (apply + (map (complexity 25) data)))
(newline)
