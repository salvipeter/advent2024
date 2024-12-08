(setq height (length data))
(setq width (length (car data)))

(setq antennas
      (filter '((g) (<> (car g) "."))
              (group
               (mapcan '((row i)
                         (mapcar '((c j)
                                   (cons c (cons i j)))
                          (chop row) (range 1 width)))
                       data (range 1 height)))))

(de inside? (pos)
    (and (> (car pos) 0) (<= (car pos) height)
         (> (cdr pos) 0) (<= (cdr pos) width)))

(de sub (a b)
    (cons (- (car a) (car b))
          (- (cdr a) (cdr b))))

(de part1 (a b)
    (filter inside?
            (list (sub a (sub b a))
                  (sub b (sub a b)))))

(de antinodes (gen lst)
    (when lst
      (let (a (car lst))
        (append (mapcan '((b) (gen a b))
                        (cdr lst))
                (antinodes gen (cdr lst))))))

(de count-antinodes (gen)
    (length
     (uniq
      (mapcan '((a)
                (antinodes gen (cdr a)))
              antennas))))

(prinl (count-antinodes part1))

(de gcd (a b)
    (if (= b 0)
        a
        (gcd b (% a b))))

(de normalize (v)
    (let (g (gcd (car v) (cdr v)))
      (cons (/ (car v) g)
            (/ (cdr v) g))))

(de negate (v)
    (cons (- (car v))
          (- (cdr v))))

(de part2 (a b)
    (let (v (normalize (sub b a))
          result (list a)
          gather '((p v)
                   (while (inside? p)
                    (push 'result p)
                    (setq p (sub p v)))))
      (gather (sub a v) v)
      (gather (sub a (negate v)) (negate v))
      result))

(prinl (count-antinodes part2))
