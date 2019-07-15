(*
 * Module for format strings
 * DURAND-MARAIS © 2019
 *)


(* Type corresponding to a position *)
type position = 
  | Center
  | Left
  | Right


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
let format_string ?pos:(pos = Center) size content : string =
  let s_content = String.length content in
  if s_content >= size then String.sub content 0 size
  else add_space pos size content

