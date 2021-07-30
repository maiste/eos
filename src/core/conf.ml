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

open Ezjsonm
open Monad

(* Name of the config's file. *)
let conf_file = "./.eos/config.json"

let auto_file = "./.eos/auto"

let template_dir = "./.eos/template"

(* Initializes [json] variable. *)
let init_json path =
  try
    let file = open_in path in
    Ok (from_channel file)
  with Sys_error msg | Parse_error (_, msg) ->
    let msg = Printf.sprintf "[Error] %s" msg in
    Error msg

(* Gets the corresponding field of [str_path] in [json]. *)
let member js str_path =
  try Ok (find js str_path)
  with Not_found ->
    let path = String.concat "" str_path in
    let msg = Printf.sprintf "[Error] can't get field %s" path in
    Error msg

(* Transforms a json [js] into a String. *)
let get_json_string js =
  try
    if js = `Null then Error "[Error] can't read json field"
    else Ok (js |> get_string)
  with Parse_error _ -> Error "[Error] wrong type"

(* Gets string content corresponding to [name] field. *)
let get_name json = member json [ "name" ] >>= get_json_string

(* Concatenates two lists of type choice. *)
let concat_choice_list o1 o2 =
  match (o1, o2) with
  | (Ok l1, Ok l2) -> Ok (List.rev_append l1 l2)
  | _ -> Error "[Error] can't reverse and append list"

(* Returns a string choice list. *)
let map_choice str l1 = Ok (List.map (fun a -> Filename.concat str a) l1)

(* Gets all regex corresponding to the [files] content. *)
let get_file_regex json =
  let rec aux acc js =
    match js with
    | `O l ->
        let append_assoc_opt acc (str, js) =
          concat_choice_list (aux (Ok []) js >>= map_choice str) acc
        in
        List.fold_left append_assoc_opt acc l
    | `A l -> List.fold_left aux acc l
    | `String str -> acc >>= fun elt -> Ok (str :: elt)
    | `Null -> Ok []
    | _ -> Error "[Error] can't find regex"
  in
  member json [ "files" ] >>= aux (Ok [])

(* Gets content corresponding to [template] field. *)
let get_user_template json = member json [ "template" ]

(* Updates the old header field. *)
let update_auto header = Writer.write auto_file header |> ignore

(* Gets the old header. *)
let get_old_header () = Reader.read_file auto_file

let get_template_path js =
  let add_dir dir = template_dir ^ "/" ^ dir |> choice in
  member js [ "model" ] >>= get_json_string >>= add_dir

(* Get the current template file *)
let get_template_json js = get_template_path js >>= init_json
