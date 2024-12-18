val size = 70

val mem = Array2.array (size + 1, size + 1, false)

fun fall n =
    let fun f (x,y) = Array2.update (mem, x, y, true)
    in (app f o List.take) (data, n) end

fun neighbors (x,y) =
    let fun valid (x,y) =
            x >= 0 andalso x <= size andalso
            y >= 0 andalso y <= size andalso
            (not o Array2.sub) (mem, x, y)
    in List.filter valid [(x-1,y),(x+1,y),(x,y-1),(x,y+1)] end

(* Recycled from 2021 / Day 15 *)
fun shortest (x,y) =
    let val m = Array2.array (size + 1, size + 1, NONE)
        val region = { base = m, row = 0, col = 0,
                       nrows = SOME (size + 1), ncols = SOME (size + 1) }
        fun update d ((x,y), changed) =
            let val old = Array2.sub (m, x, y)
            in if d + 1 < getOpt (old, d + 2)
               then ( Array2.update (m, x, y, SOME (d + 1)); true )
               else changed
            end
        fun f (_,_,NONE,changed) = changed
          | f (x,y,SOME d,changed) = foldl (update d) changed (neighbors (x,y))
        fun spread () = Array2.foldi Array2.RowMajor f false region
    in Array2.update (m, x, y, SOME 0)
     ; while spread () do ()
     ; m
    end

fun blocking n = ( fall n ; (not o isSome o Array2.sub) (shortest (0,0), size, size) )

fun main () =
    let val steps = ( fall 1024 ; (valOf o Array2.sub) (shortest (0,0), size, size) )
        fun f n = if blocking n then List.nth (data, n - 1) else f (n + 1)
        val (x, y) = f 1024
    in print (Int.toString steps ^ "\n" ^
              Int.toString x ^ "," ^ Int.toString y ^ "\n")
    end
