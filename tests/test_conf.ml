(*
 * Module to provide a test example 
 * DURAND-MARAIS © 2019
 *)
open Alcotest
open Core
open Core.Monad
open Utilitaries

let expected_res =[
  ("conf_content1.test", List.sort compare ["ex.*\\.json";"tests/"], Ok "eos");
  ("conf_content2.test", List.sort compare ["\\./src/flash"; "tests/coc.*\\.ml";"tests/banana"], Error "[Error] can't get json field");
  ("conf_content3.test", [], Ok "eos")
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
  (check (choice json)) "Check Wrong file" (Conf.init_json "Wonderland.json") (Error "[Error] can't init json")


let test_name_existance _ = 
  let aux (a,_,d) =
    let res = 
      Conf.init_json ("res/" ^ a)  
      >>= Conf.get_name in
    (check (choice string)) ("Name existed : "^a) res d
  in
  List.iter aux expected_res

let test_member _ =
  let js = Conf.init_json "res/conf_content1.test" in
  match js with 
  | Error _ -> raise Test_error
  | Ok js -> begin
      (check (choice json)) "content1 member name1" (Ok(`String "name1")) (Conf.member js ["template";"name1"]);
      (check (choice json)) "content1 member depth" (Ok(`String "element")) (Conf.member js ["depth0"; "depth1"; "depth2"]);
      (check (choice json)) "content1 member unknown" (Error "[Error] can't get json field") (Conf.member js ["unknown"]);      
    end

let test_get_template _ =
  let js = Conf.init_json "res/conf_content1.test" in
  match js with 
  | Error _ -> raise Test_error
  | Ok js ->
    (check (choice json)) "content1 get_user_template" (Ok(`O [("name1", `String "name1"); ("name2", `String "name2")])) (Conf.get_user_template js);
    let js = Conf.init_json "res/conf_content2.test" in
    match js with 
    | Error _ -> raise Test_error
    | Ok js ->
      (check (choice json)) "content2 template unknown" (Error "[Error] can't get json field") (Conf.get_user_template js)    

(* Test suite for Finder *)
let suite = [
  "List regex file equality", `Quick, test_regex_file_eq;
  "Check file non exist", `Quick, test_error_json;
  "Name existance", `Quick, test_name_existance;
  "Test function member", `Quick, test_member;
  "Get user template", `Quick, test_get_template
]


