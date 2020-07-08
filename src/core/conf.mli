(* 
 * Conf interface 
 * DURAND - MARAIS © 2019
 *)

open Monad

(** Name of the config file *)
val conf_file : string
val auto_file : string
val template_dir : string

(** init [json] variable *)
val init_json : string -> Ezjsonm.value choice

(** Get the corresponding field of [str_path] in [json] *)
val member : Ezjsonm.value -> string list -> Ezjsonm.value choice

(** Get string content corresponding to [name] field *)
val get_name : Ezjsonm.value -> string choice

(** Get all regex corresponding to the [files] content *)
val get_file_regex : Ezjsonm.value -> string list choice

(** Get content corresponding to [template] field *)
val get_user_template : Ezjsonm.value -> Ezjsonm.value choice

(* TODO *)
val updated_auto : string -> Ezjsonm.value -> Ezjsonm.value

val get_old_header : Ezjsonm.value -> string list choice

val get_template_path : Ezjsonm.value -> string choice

val get_template_json : Ezjsonm.value -> Ezjsonm.value choice
