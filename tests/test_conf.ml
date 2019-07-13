(*
 * Module to provide a test example 
 * DURAND-MARAIS © 2019
 *)
open Alcotest
open Core
open Core.Monad

let expected_res =[
  ("conf_content1.test", List.sort compare ["ex.*\\.json";"tests/"], true);
  ("conf_content2.test", List.sort compare ["\\./src/flash"; "tests/coc.*\\.ml";"tests/banana"], false);
  ("conf_content3.test", [], true)
]


let test_regex_file_eq _ = 
  let aux (a,b,_) =
    let js = match Conf.init_json ("res/" ^ a) with
      | Ok elt -> elt
      | _ -> raise Test_error 
    in 
    let res = match Conf.get_file_regex js with
      | Ok content -> (List.sort compare content)
      | Error elt -> []
    in
    (check (list string)) ("regex_content : "^ a) b res
  in
  List.iter aux expected_res

let test_error_json _ = 
  (check bool) "Check Wrong file" true (Conf.init_json "Wonderland.json" = (Error "[Error] can't init json"))


let test_name_existance _ = 
  let aux (a,_,d) =
    let res = 
      Conf.init_json ("res/" ^ a)  
      >>= Conf.get_name in
    (check bool) ("Name existed : "^a) d (res <> (Error "[Error] can't get json field"))
  in
  List.iter aux expected_res


(* Test suite for Finder *)
let suite = [
  "List regex file equality", `Quick, test_regex_file_eq;
  "Check file non exist", `Quick, test_error_json;
  "Name existance", `Quick, test_name_existance
]


