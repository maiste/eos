(*
 * Module to provide a test example 
 * DURAND-MARAIS © 2019
 *)
open Alcotest
open Core

let expected_res =[
  ("conf_content1.test", Some(List.sort compare ["ex.*\\.json";"tests/"]), true);
  ("conf_content2.test", Some(List.sort compare ["\\./src/flash"; "tests/coc.*\\.ml";"tests/banana"]), false);
  ("conf_content3.test", None, true)
]

let apply_option f = function
  | None -> None
  | Some el -> Some (f el)

let test_regex_file_eq _ = 
  let aux (a,b,_) =
    let js = Conf.init_json ("res/" ^ a) in
    (check (option (list string))) ("regex_content : "^ a) b (apply_option (List.sort compare) (Conf.get_file_regex js))
  in
  List.iter aux expected_res

let test_error_json _ = 
  (check bool) "Check Wrong file" true (Conf.init_json "Wonderland.json" = None)


let test_name_existance _ = 
  let aux (a,_,d) =
    let js = Conf.init_json ("res/" ^ a) in
    (check bool) ("Name existed : "^a) d (Conf.get_name js <> None)
  in
  List.iter aux expected_res

(* Test suite for Finder *)
let suite = [
  "List regex file equality", `Quick, test_regex_file_eq;
  "Check file non exist", `Quick, test_error_json;
  "Name existance", `Quick, test_name_existance
]


