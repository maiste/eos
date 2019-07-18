(*
 * Module to provide more testable type 
 * DURAND-MARAIS © 2019
 *)

open Alcotest


(* Return a choice [pp] function (['a Fmt.t]) with a string comparator *)
let pp_choice to_string fmt el = Fmt.string fmt (to_string el)

(* ['a] Choice testable with ['a testable] in argument *)
let choice ok_testable = result ok_testable string

(* ['a] Choice testable with [('a -> string)] function in argument *)
let choice_str ok_str = choice (of_pp (pp_choice ok_str))



(* Return a json [pp] function (['a Fmt.t]) with a string comparator *)
let pp_json fmt json = Fmt.string fmt (Ezjsonm.to_string ~minify:true (Ezjsonm.wrap json))

(* ['a testable] for [Ezjsonm.json] *)
let json = testable pp_json (=)