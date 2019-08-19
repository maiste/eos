(*
 * Update Interface
 * Durand-Marais © 2019
 *)
open Monad

(* Main function wich recovers all targeted files and updates them *)
val update_all : bool -> bool -> unit choice