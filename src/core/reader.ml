(* 
 * Module to convert a file into
 * a string list
 * DURAND - MARAIS © 2019
 *)

open Monad

type line = 
  | Line of string
  | EOF
  | Failed of string

(* Create an input channel for [filename] file *)
let open_file filename : in_channel choice = 
  try 
    Ok (open_in filename)
  with Sys_error _ -> Error "[Error] Can't open file"


(* Read on line from the [input] *)
let read_line_from input : line =
  try
    Line (input_line input)
  with End_of_file -> EOF
  | _ -> Failed "[Error] Can't read_lines"


(* Read one line frome [input] and add it 
   to [acc] *)
let rec read_lines acc input : string list choice = 
  match read_line_from input with
  | Line str -> read_lines (str::acc) input
  | EOF -> Ok (List.rev acc)
  | Failed msg -> Error msg


(* Read a content inside [file] and return it as
   None if there is an error else Some string list *)
let read_file file :string list choice  =
   (open_file file)
   >>= read_lines []



