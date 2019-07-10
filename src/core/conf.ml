(* 
 * Module to read config.json's file.
 * We need to call [init_json] before any use.
 * DURAND - MARAIS © 2019
 *)

open Yojson.Basic
open Monad


(* Name of the config's file *)
let conf_file = "./.eos/config.json"


(* init [json] variable *)
let init_json path =
  try Ok (from_file path)
  with Sys_error _ -> Error "[Error] can't init json"


(* Get the corresponding field of [str] in [json] *)
let member str js = 
  try
    Ok (Util.member str js)
  with Util. Type_error _ -> Error "[Error] can't get json field"


(* Transform a json [js] into a String *)
let get_json_string js = 
 try
    if js = `Null then
      Error "[Error] can't read json field"
    else 
      Ok (js |> Util.to_string)
  with Util.Type_error _ -> 
    Error "[Error] wrong type"


(* Get string content corresponded to [name] field *)
let get_name json = 
    member "name" json 
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


(* Get all regex corresponded to the [files] content *)
let get_file_regex json =
  let rec aux acc js =
    match js with
    | `Assoc l -> 
      let append_assoc_opt acc (str, js) =
        concat_choice_list (
          (aux (Ok []) js) 
          >>= map_choice str
        ) acc
      in List.fold_left append_assoc_opt acc l
    | `List l -> List.fold_left aux acc l
    | `String str -> 
      acc >>= (fun elt -> Ok(str :: elt))
    | `Null -> Ok []
    | _ -> Error "[Error] can't find regex"
    in
    member "files" json 
    >>= aux (Ok [])


