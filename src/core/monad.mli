(*
 * Monad either interface
 * Durand-Marais © 2019
 *)

type 'a choice = ('a, string) result

(** Bind function *)
val (>>=) : 'a choice -> ('a -> 'b choice) -> 'b choice
