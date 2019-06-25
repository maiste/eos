(* 
 * Finder interface 
 * DURAND - MARAIS © 2019
 *)

(*
   Tail-recursive search of all files corresponded to the [target] list of regex. 
   [target] list of regex to match files.
   It returns list of all targeted files.
*)
val get_all_files : string list -> string list
