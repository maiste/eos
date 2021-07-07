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

(** Name of the config files. *)
val conf_file : string

val auto_file : string

val template_dir : string

(** Inits [json] variable. *)
val init_json : string -> Ezjsonm.value choice

(** Gets the corresponding field of [str_path] in [json]. *)
val member : Ezjsonm.value -> string list -> Ezjsonm.value choice

(** Gets string content corresponding to [name] field. *)
val get_name : Ezjsonm.value -> string choice

(** Gets all regex corresponding to the [files] content. *)
val get_file_regex : Ezjsonm.value -> string list choice

(** Gets content corresponding to [template] field. *)
val get_user_template : Ezjsonm.value -> Ezjsonm.value choice

(** Update the old header save. *)
val update_auto : string list -> unit

(** Returns the value of the previous header set. *)
val get_old_header : unit -> string list choice

(** Gets the path to the template actually selected. *)
val get_template_path : Ezjsonm.value -> string choice

(** Extracts the json of the template from the configuration json. *)
val get_template_json : Ezjsonm.value -> Ezjsonm.value choice
