: less ( a b -- f )
  >R >R rules BEGIN
    DUP @ 0<> WHILE \ addr ; R: b a
    DUP @ 2R@ ROT   \ addr b a l ; R: b a
    = IF
      OVER CELL+ @ = IF DROP 2R> 2DROP TRUE EXIT THEN
    ELSE
      DROP
    THEN 2 CELLS +
  REPEAT DROP 2R> 2DROP FALSE ;

: check ( addr - f )
  BEGIN
    DUP DUP @ SWAP CELL+ @ DUP 0<> WHILE \ addr a b
    SWAP less IF DROP FALSE EXIT THEN CELL+
  REPEAT 2DROP DROP TRUE ;

: length ( addr - n ) 0 BEGIN 1+ 2DUP CELLS + @ 0= UNTIL NIP ;

: next-update ( addr -- addr' ) BEGIN CELL+ DUP @ 0= UNTIL CELL+ ;

: position ( addr x -- n )
  >R 0 SWAP BEGIN
    DUP @ 0<> WHILE \ cnt addr ; R: x
    DUP @ R@ less IF SWAP 1+ SWAP THEN CELL+
  REPEAT R> 2DROP ;

: nth ( addr n -- x )
  SWAP DUP BEGIN
    2>R 2R@ @ position OVER <> WHILE
    2R> CELL+
  REPEAT DROP R> @ R> DROP ;

: solve ( -- )
  0 0 pages BEGIN
    DUP DUP length 2/ OVER check IF \ p2 p1 addr addr len/2
      CELLS + @ ROT + SWAP
    ELSE
      nth >R ROT R> + ROT ROT
    THEN next-update
    DUP @ 0=
  UNTIL DROP . CR . CR ;

solve
