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

(* Clear bind *)
let (let*) = (>>=)

(* Apply function corresponding to [List.map f l] where [f] is a [('a -> 'b choice)] function and [l] is a ['a list]. 
 * Return a ['b list choice].
*)
let map_choice_list f l =
  let nl = 
    List.fold_left 
      (fun a b -> 
         a >>= (fun acc -> (f b) >>= (fun res -> Ok (res :: acc)))
      ) 
      (Ok([]))
      l
  in
  nl >>= (fun l -> Ok (List.rev l))

(* Bind for option *)
let (>==) obj f = 
  match obj with
  | Some a -> f a 
  | None -> None

let (let+) = (>==)

(* From monad option to monad choice *)
let opt_to_choice str_error obj =
  match obj with
  | Some a -> Ok a
  | None -> Error str_error

(* From 'a to 'a choice *)
let choice value =
  Ok value
