(*
 * Module to compare two types
 * DURAND-MARAIS © 2019
 *)

(* Compare two lists *)
let compare l1 l2 =
  let rec compare_aux e1 e2 =
    match e1, e2 with
  | [], [] -> true
  | h1::q1, h2::q2 ->
      if h1 = h2 then compare_aux q1 q2
      else false
  | _ -> false
  in compare_aux l1 l2


