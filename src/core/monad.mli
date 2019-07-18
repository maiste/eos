(*
 * Monad either interface
 * Durand-Marais © 2019
 *)

type 'a choice = ('a, string) result

(** Bind function for 'a choice *)
val (>>=) : 'a choice -> ('a -> 'b choice) -> 'b choice

(** Bind function for option *)
val (>==) : 'a option -> ('a -> 'b option) -> 'b option

(** Function to move from option to choice *)
val opt_to_choice : string -> 'a option -> 'a choice
