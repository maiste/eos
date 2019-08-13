(*
 * Interface to write into file
 * DURAND - MARAIS © 2019
 *)

open Monad

(** Write into a file *)
val write : string -> string list -> bool choice
