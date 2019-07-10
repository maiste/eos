(* 
 * Reader interface 
 * DURAND - MARAIS © 2019
 *)

open Monad

(** Return the content of the file named by [str] *)
val read_file : string -> string list choice

