(*
 * Monad either interface
 * Durand-Marais © 2019
 *)

type 'a choice = ('a, string) result

(** Bind function for 'a choice *)
val (>>=) : 'a choice -> ('a -> 'b choice) -> 'b choice

(** Apply function corresponding to [List.map f l] where [f] is a [('a -> 'b choice)] function and [l] is a ['a list]. 
 * Return a ['b list choice].
*)
val map_choice_list : ('a -> 'b choice) -> 'a list -> 'b list choice

(** Bind function for option *)
val (>==) : 'a option -> ('a -> 'b option) -> 'b option

(** Function to move from option to choice *)
val opt_to_choice : string -> 'a option -> 'a choice

(* Create a choice value *)
val choice : 'a -> 'a choice
