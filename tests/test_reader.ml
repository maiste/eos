(* 
 * Test for the reader module 
 * DURAND - MARAIS © 2019
 *)

open Alcotest
open Core


(* File original content *)
let test_content = [
  "Luke, I'm your father" ;
  "42 is the answer" ;
  "I never know if Sally tried to protect me" ;
  "For the livings!";
  ""
]

let wrong_file _ = 
  let file = Reader.read_file "wonderland" in
  match file with
  | Error a -> (check (string)) "Compare errors" "[Error] Can't open file" a
  | _ -> raise Test_error

let right_file _ = 
  let file = Reader.read_file "res/Read_content.test" in
  match file with
  | Error _ ->  raise Test_error
  | Ok  content -> 
      (check (list string)) "Compare strings" content test_content




(* General test suite *)
let suite = [
    "Wrong file", `Quick, wrong_file ;
     "Right file", `Quick, right_file ;
]
