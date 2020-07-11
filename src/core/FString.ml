(*
 * Module for format strings
 * DURAND-MARAIS © 2019
 *)

open Monad

(* Type corresponding to a position *)
type position = 
  | Center
  | Left
  | Right

(* Return [position] according to the string argument *)
let match_position = function
  | "center" -> Ok(Center)
  | "left" -> Ok(Left)
  | "right" -> Ok(Right)
  | _ -> Error "[Error] Position unknown"

(* Get string of a [position] *)
let position_str = function
  | Center -> "center"
  | Left -> "left"
  | Right -> "right"

(* Add some space *)
let add_space pos size content : string =
  let nb_blank = size - String.length content in
  match pos with
  | Center -> let space_after = nb_blank / 2 in 
    (String.make (nb_blank - space_after) ' ') 
    ^ content 
    ^ (String.make space_after ' ')
  | Left -> content ^ (String.make nb_blank ' ')
  | Right -> (String.make nb_blank ' ') ^ content


(* Return a format String with the right size and
   position *)
let format_string pos size content =
  let size =
    match size with
    | None -> String.length content
    | Some s -> s
  in
  let* pos =
    match pos with
    | None -> Ok(Left)
    | Some str -> match_position str
  in
  let s_content = String.length content in
  if s_content >= size then
    Ok (String.sub content 0 size)
  else
    Ok (add_space pos size content)

