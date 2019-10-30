(* 
 * Module to read config.json's file.
 * We need to call [init_json] before any use.
 * DURAND - MARAIS © 2019
 *)

open Ezjsonm
open Monad


(* Name of the config's file *)
let conf_file = "./.eos/config.json"
let old_template = "./.eos/old_template"
let template_file = "./.eos/template.json"

(* init [json] variable *)
let init_json path =
  try 
    let file = open_in path in
    Ok (from_channel file)
  with Sys_error _ | Parse_error _ -> Error "[Error] can't init json"


(* Get the corresponding field of [str_path] in [json] *)
let member js str_path = 
  try
    Ok (find js str_path)
  with Not_found -> Error "[Error] can't get json field"


(* Transform a json [js] into a String *)
let get_json_string js = 
  try
    if js = `Null then
      Error "[Error] can't read json field"
    else 
      Ok (js |> get_string)
  with Parse_error _ -> 
    Error "[Error] wrong type"


(* Get string content corresponding to [name] field *)
let get_name json = 
  member json ["name"] 
  >>=  get_json_string


(* Concatenate two lists of type choice *)
let concat_choice_list o1 o2 = 
  match o1, o2 with
  | Ok l1, Ok l2 -> Ok (List.rev_append l1 l2)
  | _ -> Error "[Error] can't reverse and append list"


(* Return a string choice list *)
let map_choice str l1 = 
  Ok (List.map (
      fun a -> Filename.concat str a 
    ) l1) 


(* Get all regex corresponding to the [files] content *)
let get_file_regex json =
  let rec aux acc js =
    match js with
    | `O l -> 
      let append_assoc_opt acc (str, js) =
        concat_choice_list (
          (aux (Ok []) js) 
          >>= map_choice str
        ) acc
      in List.fold_left append_assoc_opt acc l
    | `A l -> List.fold_left aux acc l
    | `String str -> 
      acc >>= (fun elt -> Ok(str :: elt))
    | `Null -> Ok []
    | _ -> Error "[Error] can't find regex"
  in
  member json ["files"]
  >>= aux (Ok [])

(* Get content corresponding to [template] field *)
let get_user_template json = 
  member json ["template"] 
