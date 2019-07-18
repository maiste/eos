(* 
 * Formatter interface 
 * DURAND - MARAIS © 2019
 *)

open Monad

(** Recover string corresponding to the mustache template *)
val get_template : Ezjsonm.value -> Mustache.t choice

(** Take user json and template json, and return the header filled with user variable *)
val formatter : Ezjsonm.value -> Ezjsonm.value -> string choice
