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

(* Cuts list in two part with all element with the index strictly under [i]
   in the first part and other in the second. *)
let cut_list i l =
  let rec aux i l tmp =
    if i <= 0 then (List.rev tmp, l)
    else
      match l with
      | [] -> (List.rev tmp, l)
      | h :: q -> aux (i - 1) q (h :: tmp)
  in
  aux i l []

(* Applies flag [c] for confirm mode and [v] for verbose mode. *)
let change_file v c content file =
  let change =
    if c then (
      Printf.printf "Add header to the file '%s' ? [y/n]" file ;
      let res = read_line () in
      if res = "" then true else String.get res 0 = 'y')
    else true
  in
  if change then
    let updated = Writer.write file content in
    if v then
      match updated with
      | Ok b ->
          if b then Printf.printf "Modified file : %s\n" file
          else Printf.printf "Unmodified file : %s\n" file
      | Error e -> Printf.printf "Problem to modify file '%s' : %s\n" file e

(* Comments [hdr] depending of [file] extension. *)
let comment_hdr hdr file cmt =
  let ext = Filename.extension file in
  let ext = String.sub ext 1 (String.length ext - 1) in
  Comment.build_header hdr ext cmt

(* Looks on the content of a specific file and determines if we
   need to change the file. *)
let update v c comment oh nh file =
  let nh = comment_hdr nh file comment in
  let oh = comment_hdr oh file comment in
  match (oh, nh) with
  | (Ok oh, Ok nh) -> (
      let change_content nh start content =
        let without_hdr = snd (cut_list start content) in
        List.rev_append (List.rev nh) without_hdr
      in
      let apply content =
        if Comparator.compare oh nh then (
          if Comparator.begin_of nh content = false then
            change_file v c (change_content nh 0 content) file)
        else if Comparator.begin_of oh content then
          change_file v c (change_content nh (List.length oh) content) file
        else if Comparator.begin_of nh content = false then
          change_file v c (change_content nh 0 content) file
      in
      match Reader.read_file file with
      | Ok content -> apply content
      | Error e -> Printf.printf "%s\n" e)
  | (Error e, _) -> Printf.printf "%s\n" e
  | (_, Error e) -> Printf.printf "%s\n" e

(* Main function wich recovers all targeted files and updates them. *)
let update_all v c =
  let* conf = Conf.init_json Conf.conf_file in
  let* files = Conf.get_file_regex conf >>= Finder.get_files in
  let* old_head = Conf.get_old_header () in
  let* template = Conf.get_template_json conf in
  let* new_head =
    let* header = Formatter.formatter template conf in
    Ok (String.split_on_char '\n' header)
  in
  let _ = Conf.update_auto new_head in
  let* map_comment = Comment.user_map conf in
  let update_with_new comment oh nh l =
    Ok (List.iter (update v c comment oh nh) l)
  in
  update_with_new map_comment old_head new_head files
