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

(* Auxilliary function to write content. *)
let rec writer chan lst =
  match lst with
  | [] ->
      close_out chan ;
      Ok true
  | h :: q ->
      output_string chan (h ^ "\n") ;
      writer chan q

(** Writes a file. *)
let write file content =
  if Sys.file_exists file then
    let out_chan = open_out file in
    writer out_chan content
  else Error "[Error] Can't find file"
