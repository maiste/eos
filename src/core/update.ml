(*
 * Update Module
 * Durand-Marais © 2019
 *)

open Monad

(* Cut list in two part with all element with the index strictly under [i] in the first part and other in the second *)
let cut_list i l =
  let rec aux i l tmp =
    if i <= 0 then (List.rev tmp,l)
    else 
      match l with
      | [] -> (List.rev tmp,l)
      | h::q -> aux (i-1) q (h :: tmp)
  in
  aux i l [] 

(* Apply flag [c] for confirm mode and [v] for verbose mode *)
let change_file v c content file =
  let change = 
    if c then 
      begin 
        Printf.printf ("Add header to the file '%s' ? [y/n]") file;
        let res = read_line () in
        if res = "" then true
        else String.get res 0 = 'y'
      end 
    else 
      true
  in
  if change then
    let updated = Writer.write file content in
    if v then 
      match updated with 
      | Ok b -> 
        if b then
          Printf.printf "Modified file : %s\n" file
        else 
          Printf.printf "Unmodified file : %s\n" file
      | Error e -> Printf.printf "Problem to modify file '%s' : %s\n" file e

(* Comments [hdr] depending of [file] extension *)
let comment_hdr hdr file cmt =
  let ext = Filename.extension file in 
  let ext = String.sub ext 1 (String.length ext - 1) in
  Comment.build_header hdr ext cmt

(* Looks on the content of a specific file and determines if we need to change the file *)
let update v c comment oh nh file =
  let nh = comment_hdr nh file comment in
  let oh = comment_hdr oh file comment in
  match oh, nh with 
  | Ok oh, Ok nh ->
    begin
      let change_content nh start content = 
        let without_hdr = snd (cut_list start content) in
        List.rev_append (List.rev nh) without_hdr
      in
      let apply content = 
        if Comparator.compare oh nh then 
          begin
            if Comparator.begin_of nh content = false then 
              (change_file v c (change_content nh 0 content) file)
          end
        else 
        if Comparator.begin_of oh content then
          (change_file v c (change_content nh (List.length oh) content) file)
        else 
        if Comparator.begin_of nh content = false then 
          (change_file v c (change_content nh 0 content) file)
      in
      match Reader.read_file file with
      | Ok content -> apply content
      | Error e -> Printf.printf "%s\n" e
    end
  | Error e, _ -> Printf.printf "%s\n" e
  | _, Error e -> Printf.printf "%s\n" e

(* Main function wich recovers all targeted files and updates them *)
let update_all v c =
  let files = (Conf.init_json Conf.conf_file) 
    >>= Conf.get_file_regex 
    >>= Finder.get_files in 
  let old_head = Reader.read_file Conf.auto_conf in
  let templ = Conf.init_json Conf.template_file in
  let user = Conf.init_json Conf.conf_file in
  let arg_head = match templ, user with
    | Ok a, Ok b -> Ok (a,b)
    | Error a, _ -> Error a
    | _, Error b -> Error b 
  in
  let new_head = arg_head 
    >>= (fun (a,b) -> Formatter.formatter a b) 
    >>= (fun res -> Ok (String.split_on_char '\n' res)) in
  let map_comment = user >>= Comment.user_map in
  let f comment oh nh l = Ok (List.iter (update v c comment oh nh) l) in
  map_comment 
  >>= (fun cmt -> old_head 
        >>= (fun oh -> 
            new_head 
            >>= (fun nh ->
                files 
                >>= f cmt oh nh
              )
          )
      )
