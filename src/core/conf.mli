(* 
 * Conf interface 
 * DURAND - MARAIS © 2019
 *)

(* Name of the config's file *)
val conf_file : string

(* init [json] variable *)
val init_json : string -> Yojson.Basic.t option

(* Get string content corresponded to [name] field *)
val get_name : Yojson.Basic.t option -> string option

(* Get all regex corresponded to the [files] content *)
val get_file_regex : Yojson.Basic.t option -> string list option
