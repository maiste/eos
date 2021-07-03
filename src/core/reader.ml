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

type line = Line of string | EOF | Failed of string

(* Creates an input channel for [filename] file. *)
let open_file filename : in_channel choice =
  try Ok (open_in filename)
  with Sys_error _ -> Error "[Error] Can't open file"

(* Reads on line from the [input]. *)
let read_line_from input : line =
  try Line (input_line input) with
  | End_of_file ->
      close_in input ;
      EOF
  | _ ->
      close_in input ;
      Failed "[Error] Can't read_lines"

(* Reads one line frome [input] and add it to [acc]. *)
let rec read_lines acc input : string list choice =
  match read_line_from input with
  | Line str -> read_lines (str :: acc) input
  | EOF -> Ok (List.rev acc)
  | Failed msg -> Error msg

(* Reads a content inside [file] and return it as None if there
   is an error else Some string list. *)
let read_file file : string list choice =
  let* f_in = open_file file in
  read_lines [] f_in
