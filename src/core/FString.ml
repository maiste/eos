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

(* Type corresponding to a position. *)
type position = Center | Left | Right

(* Returns [position] according to the string argument. *)
let match_position = function
  | "center" -> Ok Center
  | "left" -> Ok Left
  | "right" -> Ok Right
  | _ -> Error "[Error] Position unknown"

(* Gets string of a [position]. *)
let position_str = function
  | Center -> "center"
  | Left -> "left"
  | Right -> "right"

(* Adds some space. *)
let add_space pos size content : string =
  let nb_blank = size - String.length content in
  match pos with
  | Center ->
      let space_after = nb_blank / 2 in
      String.make (nb_blank - space_after) ' '
      ^ content
      ^ String.make space_after ' '
  | Left -> content ^ String.make nb_blank ' '
  | Right -> String.make nb_blank ' ' ^ content

(* Returns a format String with the right size and
   position. *)
let format_string pos size content =
  let size = match size with None -> String.length content | Some s -> s in
  let* pos =
    match pos with None -> Ok Left | Some str -> match_position str
  in
  let s_content = String.length content in
  if s_content >= size then Ok (String.sub content 0 size)
  else Ok (add_space pos size content)
