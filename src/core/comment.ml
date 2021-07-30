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
open Ezjsonm

(* Module to manage string map. *)
module Map_Str = Map.Make (String)

(* Type commentary. *)
type comment = Block of string * string * string | Inline of string

(* Auxiliary constructors. *)
let inline s = Inline s

let block (s1, s2, s3) = Block (s1, s2, s3)

(* Default commentary list. *)
let default =
  [ ([ "c"; "java"; "go" ], Block ("/*", " * ", " */"));
    ([ "py"; "sh" ], Inline "#");
    ([ "ml"; "mli" ], Block ("(*", " * ", " *)"));
    ([ ".vim" ], Inline "\"")
  ]

(* Returns an inline value. *)
let get_inline v : comment choice =
  match v with
  | `String s -> Ok (inline s)
  | _ -> Error "[Error] Inline needs a String value"

(* Returns a block value. *)
let get_block v =
  ( (try Ok (get_list get_string v)
     with _ -> Error "[Error] Block needs an array of strings")
  >>= fun l ->
    try Ok (List.nth l 0, List.nth l 1, List.nth l 2)
    with _ -> Error "[Error] Block needs exactly three strings" )
  >>= fun t -> Ok (block t)

(* Gets ext value. *)
let get_ext v =
  let rec aux l =
    match l with
    | [] -> Error "[Error] Can't get field ext"
    | ("ext", value) :: _ -> (
        try Ok (get_list get_string value)
        with _ -> Error "[Error] Ext needs a list of strings")
    | _ :: q -> aux q
  in
  aux v

(* Gets extension content. *)
let get_ext_type v =
  let rec aux l =
    match l with
    | [] -> Error "[Error] Can't find inline or block value"
    | ("inline", value) :: _ -> get_inline value
    | ("block", value) :: _ -> get_block value
    | _ :: q -> aux q
  in
  aux v

(* Creates a comment. *)
let create_com m v =
  let ext = get_ext v in
  let ext_type = get_ext_type v in
  match (ext, ext_type) with
  | (Ok e, Ok t) ->
      Ok (List.fold_left (fun map elt -> Map_Str.add elt t map) m e)
  | (Ok _, Error a) -> Error a
  | (Error a, _) -> Error a

(* Builds a default list. *)
let build_map lst =
  let from_list lst v m =
    List.fold_left (fun map elt -> Map_Str.add elt v map) m lst
  in
  List.fold_left
    (fun map elt ->
      let value = snd elt in
      from_list (fst elt) value map)
    Map_Str.empty
    lst

(* Builds user map. *)
let build_user_map m l =
  let rec aux l acc =
    match l with
    | [] -> Ok acc
    | h :: q ->
        let* o_list =
          try Ok (get_dict h) with _ -> Error "[Error] Can't get object"
        in
        create_com acc o_list >>= aux q
  in
  aux l m

(* Updates build final list. *)
let user_map js =
  let map = build_map default in
  match Conf.member js [ "comments" ] with
  | Ok elt -> (
      match elt with
      | `A lst -> build_user_map map lst
      | _ -> Error "[Error] Field comments is an array")
  | _ -> Ok map

(* Builds header with good comments. *)
let build_header header ext m =
  let f s acc elt = (s ^ elt) :: acc in
  let map = try Map_Str.find ext m with Not_found -> Inline "#" in
  match map with
  | Block (beg, mid, ed) ->
      Ok (ed :: List.fold_left (f mid) [ beg ] header |> List.rev)
  | Inline mid -> Ok (List.fold_left (f mid) [] header |> List.rev)
