(**
 * Interface for the module 
 * FString 
 * DURAND-MARAIS © 2019
 *)


(** Type corresponding to a position *)
type position = 
  | Center (** Center align (add space before and after the string if needed) *)
  | Left (** Left align (add after the string if needed) *)
  | Right (** Right align (add before the string if needed) *)


(** Main function to format string where [pos] is the position of the string,
   [size] the size of the string and [content] the content of the string *)
val format_string : ?pos : position -> int ->  string ->  string
