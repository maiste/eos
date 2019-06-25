(* 
 * Module in charge of return 
 * all files targeted by eos
 * DURAND - MARAIS © 2019
 *)

(* This function checks if a string passed in argument is a directory. 
    The default value is Sys.is_directory function.
*)
let check_directory path : bool = Sys.is_directory path

(*
   This function returns if a file is targeted.
*)
let is_targeted target path : bool =
  let exist (el : string) : bool =
    let el_len = String.length el in
    let dir = 
      if el_len > 0 
      then String.get el (String.length el - 1) = '/'  
      else false
    in
    if dir && not (check_directory path) then false
    else begin
      let el = 
        if dir 
        then String.sub el 0 (String.length el - 1) 
        else el 
      in 
      let regex = Str.regexp el in
      try Str.search_backward regex path (String.length path - 1) > -1
      with Not_found -> false
    end
  in
  List.exists exist target

(*
   Tail-recursive search (and add to [l]) of all files in directories and sub-directories given at second argument. 
   If the second argument is not a directory, we add it in the list [l].
*)
let rec get_sub_files l path : string list =
  if not (check_directory path) then
    path :: l
  else
    let all_f = Sys.readdir path in
    let aux (acc : string list) (str : string) =
      if str = "." || str = ".." then acc
      else 
        let file = Filename.concat path str in
        get_sub_files acc file
    in
    Array.fold_left aux l all_f

(**
   Tail-recursive search of all files corresponded to the [target] list of regex. 
*)
let get_all_files target : string list =
  let rec get_file target path acc =
    let all_f = Sys.readdir path in
    let aux acc str = 
      if str = "." || str = ".." then acc
      else 
        let file = Filename.concat path str in
        if is_targeted target file then
          get_sub_files acc file
        else if check_directory file then get_file target file acc
        else acc
    in
    Array.fold_left aux acc all_f
  in
  get_file target "." []
