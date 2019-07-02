(*
 * Monad Module
 * Durand-Marais © 2019
 *)

type 'a choice = ('a, string) result

let (>>=) obj f =
  match obj with
  | Ok a -> f a
  | Error b -> Error b
