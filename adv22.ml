let step n =
  let m = 16777216 in
  let n' = n * 64 lxor n mod m in
  let n'' = n' / 32 lxor n' mod m in
  n'' * 2048 lxor n'' mod m

let rec after k n =
  if k = 0 then n else after (k - 1) (step n)

let p1 = List.map (after 2000) data |> List.fold_left (+) 0

module OrderedIntList =
  struct
    let compare = List.compare Int.compare
    type t = int list
  end

module LMap = Map.Make(OrderedIntList)
module LSet = Set.Make(OrderedIntList)

let add_change d = function
  | [_;a;b;c] -> [a;b;c;d]
  | xs        -> xs @ [d]

(*
  Here `scores` is an LMap mapping price changes to price sums.
  The result is a modified map where the monkey with starting
  secret `n` is taken into account.
  Since the first match is what counts, the changes already seen
  are noted in an LSet, and only new ones are processed.
 *)
let process scores n =
  let rec f prev curr k acc seen scores =
    if k > 2000 then scores else
      let price = curr mod 10 in
      let acc' = add_change (price - prev mod 10) acc in
      let seen' = LSet.add acc' seen in
      let scores' =
        if k < 4 || LSet.mem acc' seen then scores else
          let count = function
            | None     -> Some price
            | Some old -> Some (old + price) in
          LMap.update acc' count scores
      in f curr (step curr) (k + 1) acc' seen' scores'
  in f n (step n) 1 [] LSet.empty scores

let p2 = List.fold_left process LMap.empty data
         |> LMap.to_list |> List.map snd |> List.fold_left max 0

;; p1 |> string_of_int |> print_endline
;; p2 |> string_of_int |> print_endline
