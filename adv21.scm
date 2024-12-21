;;; List utilities

;;; Removes the last element from LST.
(define (butlast lst)
  (if (null? (cdr lst))
      '()
      (cons (car lst) (butlast (cdr lst)))))

;;; Removes the first occurrence of X from LST.
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
    ((d) (cons (car pos) (+ (cdr pos) 1)))))

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

;;; Is the sequence of directions valid, starting from
;;; the given position on a numeric keypad?
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

;;; Is the sequence of directions valid, starting from
;;; the given position on a directional keypad?
(define (direction-valid? pos dirs)
  (or (null? dirs)
      (let ((p (step pos (car dirs))))
        (and (>= (car p) 0) (< (car p) 3)
             (>= (cdr p) 0) (< (cdr p) 2)
             (not (equal? p '(0 . 0)))
             (direction-valid? p (cdr dirs))))))

;;; The list of directions to reach TO from FROM.
;;; Does not include the final A keypress.
(define (move-list from to)
  (let ((dx (- (car to) (car from)))
        (dy (- (cdr to) (cdr from))))
    (append (vector->list (make-vector (abs dx) (if (< dx 0) 'l 'r)))
            (vector->list (make-vector (abs dy) (if (< dy 0) 'u 'd))))))

;;; A list of all valid permutations to reach TO from FROM.
;;; Validity of a given sequence of directions is checked by PRED.
;;; The result includes the final A keypress, as well.
(define (valid-permutations from to pred)
  (let ((result '()))
    (letrec ((rec (lambda (dirs acc)
                    (if (null? dirs)
                        (when (pred from (reverse acc))
                          (set! result (cons (reverse (cons 'a acc)) result)))
                        (for-each (lambda (d)
                                    (when (member d dirs)
                                      (rec (remove d dirs) (cons d acc))))
                                  '(l r d u))))))
      (rec (move-list from to) '()))
    result))

;;; Shortest sequence search

;;; Given a list of permutations, compute the minimal length
;;; when processed over RELAYS number of directional keypads.
(define (minimal-permutation-length perms relays)
  (define (length-sum seq)
    (apply + (map (dir-seq-length relays)
                  (cons 'a (butlast seq)) seq)))
  (apply min (map length-sum perms)))

;;; Called as (DIR-SEQ-LENGTH RELAYS), it returns a function of two parameters,
;;; (FROM TO), which computes the minimal number of keypresses to move
;;; from FROM to TO when processed over RELAYS number of directional keypads.
;;; Uses a cache for efficiency.
(define dir-seq-length
  (let ((cache '()))
    (lambda (relays)
      (lambda (from to)
        (let ((cached (assoc (list relays from to) cache)))
          (if cached
              (cdr cached)
              (let* ((p0 (direction-pos from))
                     (p1 (direction-pos to))
                     (seqs (valid-permutations p0 p1 direction-valid?))
                     (result (if (= relays 1)
                                 (apply min (map length seqs))
                                 (minimal-permutation-length seqs (- relays 1)))))
                (set! cache (cons (cons (list relays from to) result) cache))
                result)))))))

;;; Same as DIR-SEQ-LENGTH, but FROM and TO are
;;; characters of a numeric keypad.
(define (num-seq-length relays)
  (lambda (from to)
    (let ((p0 (numeric-pos from))
          (p1 (numeric-pos to)))
      (minimal-permutation-length
       (valid-permutations p0 p1 numeric-valid?)
       relays))))

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
