(*
 * Module to write into file
 * DURAND - MARAIS © 2019
 *)


(* Auxilliary function to write content *)
let rec writer chan lst = 
  match lst with
  | [] -> close_out chan ; Ok true
  | h::q -> (
    output_string chan (h^"\n") ;
    writer chan q
  )

(** Write a file *)
let write file content = 
  if Sys.file_exists file then
    let out_chan = open_out file in
    writer out_chan content
  else
    Error "[Error] Can't find file"
