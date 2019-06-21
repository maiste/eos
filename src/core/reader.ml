(* 
 * Module to convert a file into
 * a string list
 * @author MARAIS - DURAND © 2019
 *)


(* Create an input channel for [filename] file *)
let open_file filename : in_channel option = 
  try 
    Some (open_in filename)
  with Sys_error _ -> None


(* Read on line from the [input] *)
let read_line_from input : string option =
  try
    Some (input_line input)
  with End_of_file -> None


(* Read one line frome [input] and add it 
   to [acc] *)
let rec read_lines input acc : string list = 
  let line = read_line_from input in
  match line with
  | None -> acc
  | Some element -> read_lines input (element::acc) 


(* Read a content inside [file] and return it as
   None if there is an error else Some string list *)
let read_file file : string list option =
  let input = open_file file in
  match input with
  | None -> None
  | Some in_chan -> Some (
    read_lines in_chan [] |> List.rev
   )



