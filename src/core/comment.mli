(*
 * Interface for comment.ml to manage
 * header building
 * DURAND-MARAIS © 2019
 *)

open Monad
open Ezjsonm

module Map_Str : Map.S

type comment =
  | Block of string*string*string
  | Inline of string

(* Create the user map *)
val user_map : value -> comment Map_Str.t choice

(* Build a header *)
val build_header : string list -> string -> comment Map_Str.t -> string list choice
