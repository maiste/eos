(*
 * Module to manage commentaries
 * DURAND - MARAIS © 2019
 *)


open Monad
open Ezjsonm



(* Module to manage string map *)
module Map_Str = Map.Make(String)

(* Type commentary *)
type comment = 
  | Block of string*string*string
  | Inline of string

(* Auxiliary constructors *)
let inline s = Inline s
let block (s1,s2,s3) = Block (s1,s2,s3)



(* default commentary list *)
let default = [
  ["c" ; "java" ; "go"], Block ("/*", " * ", " */")  ;
  ["py" ; "sh"], Inline "#" ;
  ["ml" ; "mli"], Block ("(*", " * ", " *)")  ;
  [".vim"], Inline "\"";
]

(* Return an inline value *)
let get_inline v : comment choice =
  match v with
  | `String s -> Ok (inline s)
  | _ -> Error "[Error] Inline needs a String value"

(* Return a block value *)
let get_block v =
  (
    try Ok (get_list get_string v)
    with _ -> Error "[Error] Block needs an array of strings"
  ) >>=
  (
    fun l ->
      try Ok (List.nth l 0 , List.nth l 1, List.nth l 2)
      with _ -> Error "[Error] Block needs exactly three strings"
  ) >>= (fun t ->  Ok (block t))

(* Get ext value *)
let get_ext v =
  let rec aux l =
    match l with
    | [] -> Error "[Error] Can't get field ext"
    | ("ext", value)::_ -> (
        try Ok (get_list get_string value)
        with _ -> Error "[Error] Ext needs a list of strings"
      )
    | _::q -> aux q
  in aux v

(* Build get extension content *)
let get_ext_type v =
  let rec aux l =
    match l with
    | [] -> Error "[Error] Can't find inline or block value"
    | ("inline", value)::_ -> get_inline value
    | ("block", value)::_ -> get_block value
    | _::q -> aux q 
  in aux v



(* Create a comment *)
let create_com m v =
  let ext = get_ext v in
  let ext_type = get_ext_type v in
  match ext, ext_type with
  | Ok e, Ok t -> Ok (
      List.fold_left (
        fun map elt -> Map_Str.add elt t map
      ) m e
  )
  | Ok _, Error a -> Error a
  | Error a, _ -> Error a

(* Build a default list *)
let build_map lst =
  let from_list lst v m =
    List.fold_left
      (fun map elt ->
        Map_Str.add elt v map
      ) m lst
  in
  List.fold_left
    (fun map elt ->
        let value = snd elt in
        from_list (fst elt) value map
    ) Map_Str.empty lst

(* Build user map *)
let build_user_map m l =
  let rec aux l acc =
    match l with
    | [] -> Ok (acc)
    | h::q ->
        let o_list =
          try Ok (get_dict h)
          with _ -> Error "[Error] Can't get object"
        in o_list >>= create_com acc >>= aux q
    in aux l m



(* Update build final list *)
let user_map js =
  let map = build_map default in
  match Conf.member js ["comments"] with
  | Ok elt ->
    (match elt with
      | `A lst -> build_user_map map lst
      | _ -> Error "[Error] Field comments is an array")
  | _ -> Ok map


(* Build header with good comments *)
let build_header header ext m =
  let f s acc elt = (s^elt)::acc in
  let map =
    try Map_Str.find ext m
    with Not_found -> Inline "#"
  in
  match map with
  | Block (beg, mid ,ed) ->
      Ok (
        ed::(List.fold_left (f mid) [beg] header)
        |> List.rev
      )
  | Inline mid ->
      Ok (
        List.fold_left (f mid) [] header
        |> List.rev
      )
