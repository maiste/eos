(**********************************************************************************)
(* MIT License                                                                    *)
(*                                                                                *)
(* Copyright (c) 2019 Étienne Marais <etienne@maiste.fr>                          *)
(* Copyright (c) 2019 Xavier Durand <xavier75013@gmail.com>                       *)
(*                                                                                *)
(* Permission is hereby granted, free of charge, to any person obtaining a copy   *)
(* of this software and associated documentation files (the "Software"), to deal  *)
(* in the Software without restriction, including without limitation the rights   *)
(* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      *)
(* copies of the Software, and to permit persons to whom the Software is          *)
(* furnished to do so, subject to the following conditions:                       *)
(*                                                                                *)
(* The above copyright notice and this permission notice shall be included in all *)
(* copies or substantial portions of the Software.                                *)
(*                                                                                *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     *)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    *)
(* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         *)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  *)
(* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  *)
(* SOFTWARE.                                                                      *)
(**********************************************************************************)

open Monad

(* This function checks if a string passed in argument is a directory. 
    The default value is Sys.is_directory function. *)
let check_directory path : bool =
  try Sys.is_directory path with Sys_error _ -> false

(* This function returns if a file is targeted. *)
let is_targeted target path : bool =
  let exist (el : string) : bool =
    if el = "" then false
    else
      let el_len = String.length el in
      let dir =
        if el_len > 0 then String.get el (String.length el - 1) = '/' else false
      in
      if dir && not (check_directory path) then false
      else
        let el = if dir then String.sub el 0 (String.length el - 1) else el in
        let regex = Str.regexp el in
        try Str.search_backward regex path (String.length path - 1) > -1
        with Not_found -> false
  in
  List.exists exist target

(* Tail-recursive search (and add to [l]) of all files in directories and
   sub-directories given at second argument. If the second argument is not
   a directory, we add it in the list [l]. *)
let rec get_sub_files l path : string list =
  if not (check_directory path) then path :: l
  else
    let all_f = Sys.readdir path in
    let aux (acc : string list) (str : string) =
      if str = "." || str = ".." then acc
      else
        let file = Filename.concat path str in
        get_sub_files acc file
    in
    Array.fold_left aux l all_f

(* Tail-recursive search of all files corresponded to the
   [target] list of regex. *)
let get_all_files target : string list =
  let rec get_file target path acc =
    let all_f = Sys.readdir path in
    let aux acc str =
      if str = "." || str = ".." then acc
      else
        let file = Filename.concat path str in
        if is_targeted target file then get_sub_files acc file
        else if check_directory file then get_file target file acc
        else acc
    in
    Array.fold_left aux acc all_f
  in
  get_file target "." []

let get_files target : string list choice =
  match get_all_files target with
  | [] -> Error "[Warning] can't find any file"
  | lst -> Ok lst
