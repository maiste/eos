(* 
 * Module to read config.json's file.
 * We need to call [init_json] before any use.
 * DURAND - MARAIS © 2019
 *)

open Yojson.Basic

(* Name of the config's file *)
let conf_file = "./eos/config.json"

let apply_option f = function
  | None -> None
  | Some el -> Some (f el)

(* init [json] variable *)
let init_json path =
  try Some (from_file path)
  with Sys_error msg -> let _ = msg in (* print error msg *) None

(* String description of a json element *)  
let string_of_json = function
  | `Assoc _ -> "assoc"
  | `Bool _ -> "boolean"
  | `Float _ -> "float"
  | `Int _ -> "integer"
  | `List _ -> "List"
  | `Null -> "null"
  | `String _ -> "string"

(* Get the corresponding fiel of [str] in [json] *)
let member str js = 
  try
    apply_option (Util.member str) js
  with Util. Type_error (msg, _) -> let _ = msg in (* print error msg *) None

(* Get string content corresponded to [name] field *)
let get_name json = 
  try
    match member "name" json with
    | None -> None
    | Some js ->
      if js = `Null then (* print null msg : "no name existed" *) None
      else
        Some (js |> Util.to_string)
  with Util.Type_error (msg, _) -> 
    (* print error msg *) let _ = msg in
    None

(* Get all regex corresponded to the [files] content *)
let get_file_regex json =
  let files = member "files" json in
  let rec aux acc js =
    match js with
    | `Assoc l -> 
      let concat_option_list lo1 lo2 =
        match lo1, lo2 with
        | Some l1, Some l2 -> Some (List.rev_append l1 l2)
        | _ -> None
      in
      let append_assoc_opt acc (str, js) =
        concat_option_list
          (apply_option 
             (List.map 
                (fun a -> Filename.concat str a)
             ) 
             (aux (Some []) js)
          )
          acc
      in
      List.fold_left
        append_assoc_opt
        acc
        l 
    | `List l -> List.fold_left aux acc l
    | `String str -> apply_option (fun a -> str :: a) acc
    | `Null -> Some ([])
    | _ -> let _ = "Wrong type : get " ^ (string_of_json js) (* print error msg *) in None
  in
  match files with 
  | None -> None
  | Some js -> aux (Some []) js


