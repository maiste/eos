(* 
 * Conf interface 
 * DURAND - MARAIS © 2019
 *)

open Monad

(* Name of the config's file *)
val conf_file : string

(* init [json] variable *)
val init_json : string -> Yojson.Basic.t choice

(* Get string content corresponded to [name] field *)
val get_name : Yojson.Basic.t -> string choice

(* Get all regex corresponded to the [files] content *)
val get_file_regex : Yojson.Basic.t -> string list choice
