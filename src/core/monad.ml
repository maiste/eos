(*
 * Monad Module
 * Durand-Marais © 2019
 *)

type 'a choice = ('a, string) result

(* Bind for 'a choice *)
let (>>=) obj f =
  match obj with
  | Ok a -> f a
  | Error b -> Error b

(* Bind for option *)
let (>==) obj f = 
  match obj with
  | Some a -> f a 
  | None -> None

(* From monad option to monad choice *)
let opt_to_choice str_error obj =
  match obj with
  | Some a -> Ok a
  | None -> Error str_error
