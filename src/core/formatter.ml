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

let value_to_t js = match js with `A l -> `A l | `O l -> `O l | _ -> wrap js

(* Recovers string corresponding to the mustache template. *)
let get_template json =
  let* conf = Conf.member json [ "template" ] in
  let* template =
    try Ok (get_string conf) with _ -> Error "[Error] Template Parse Error"
  in
  try Ok (Mustache.of_string template)
  with _ -> Error "[Error] Template Parser Error"

(* Gets only variable declared in the template. *)
let get_template_var json =
  match json with
  | `Null | `Bool _ | `Float _ | `String _ | `A _ -> json
  | `O l -> `O (List.filter (fun (str, _) -> str <> "template") l)

(* Formats user variable with the template configuration of variable. *)
let format_user_var templ user =
  let rec aux format user =
    let len = try Some (get_int (find format [ "size" ])) with _ -> None in
    let pos =
      try Some (get_string (find format [ "position" ])) with _ -> None
    in
    let make_String a = Ok (string a) in
    match user with
    | `Null -> Ok user
    | `Bool b ->
        FString.format_string pos len (string_of_bool b) >>= make_String
    | `Float f ->
        FString.format_string pos len (Printf.sprintf "%.12g" f) >>= make_String
    | `String str -> FString.format_string pos len str >>= make_String
    | `A l ->
        let* l = map_choice_list (aux format) l in
        Ok (`A l)
    | `O l ->
        let format_object (str, v) =
          try
            let format = find format [ str ] in
            let* obj = aux format v in
            Ok (str, obj)
          with Not_found -> Ok (str, v)
        in
        let* obj = map_choice_list format_object l in
        Ok (`O obj)
  in
  aux templ user

(* Takes template json and user json, and return the header
   filled with user variable. *)
let formatter template_json user =
  let* template = get_template template_json in
  let* user_var = Conf.get_user_template user in
  let template_var = get_template_var template_json in
  let* json = format_user_var template_var user_var in
  Ok (Mustache.render template (value_to_t json))
