(**
 * Interface for the module 
 * FString 
 * DURAND-MARAIS © 2019
*)

open Monad

(** Type corresponding to a position *)
type position = 
  | Center (** Center align (add space before and after the string if needed) *)
  | Left (** Left align (add after the string if needed) *)
  | Right (** Right align (add before the string if needed) *)

(** Get string of a [position] *)
val position_str : position -> string

(** Main function to format string where [pos] is the position of the string,
    [size] the size of the string and [content] the content of the string *)
val format_string : string option -> int option -> string -> string choice
