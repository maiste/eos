(* 
 * Module for formatting user variable
 * according to the template
 * DURAND - MARAIS © 2019
 *)

open Ezjsonm
open Monad

let value_to_t js = 
  match js with
  | `A l -> `A l
  | `O l -> `O l
  | _ -> (wrap js)

(* Recover string corresponding to the mustache template *)
let get_template json =
  Conf.member json ["template"] 
  >>= (fun a -> try Ok (get_string a) with _ -> Error "[Error] Template Parse Error") 
  >>= (fun a -> try Ok (Mustache.of_string a) with _ -> Error "[Error] Template Parser Error")

(* Get only variable declared in the template *)
let get_template_var json =
  match json with
  | `Null | `Bool _ | `Float _ | `String _ | `A _ -> json
  | `O l -> `O (List.filter (fun (str,_) -> str <> "template") l)

(* Format user variable with the template configuration of variable *)
let format_user_var templ user =
  let rec aux format user =
    let len = try Some (get_int (find format ["size"])) with _ -> None in
    let pos = try Some (get_string (find format ["position"])) with _ -> None in
    let make_String a = Ok (string a) in
    match user with
    | `Null -> Ok(user)
    | `Bool b -> FString.format_string pos len (string_of_bool b) >>= make_String
    | `Float f -> FString.format_string pos len (Printf.sprintf "%.12g" f) >>= make_String
    | `String str -> FString.format_string pos len str >>= make_String
    | `A l -> map_choice_list (aux format) l >>= (fun l -> Ok (`A l))
    | `O l -> 
      let format_object (str, v) =
        try 
          let format = find format [str] in
          (aux format v
           >>= (fun v -> Ok (str, v)))
        with Not_found -> Ok(str, v)
      in
      map_choice_list format_object l 
      >>= (fun l -> Ok (`O l))
  in
  aux templ user

(* Take user json and template json, and return the header filled with user variable *)
let formatter templ user =
  let must_templ = get_template templ in
  let user_var = Conf.get_user_template user in
  let templ_var = get_template_var templ in
  let format_var = user_var >>= (format_user_var templ_var) in
  must_templ 
  >>= 
  (fun tmpl ->
     format_var 
     >>= 
     (fun json -> Ok (Mustache.render tmpl (value_to_t json)))
  )