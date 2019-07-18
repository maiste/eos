(* 
 * Test for the reader module 
 * DURAND - MARAIS © 2019
 *)

open Alcotest
open Core
open Utilitaries


(* File original content *)
let test_content = [
  "Luke, I'm your father" ;
  "42 is the answer" ;
  "I never know if Sally tried to protect me" ;
  "For the livings!";
  ""
]

let wrong_file _ = 
  (check (choice (list string))) "Compare errors" (Error "[Error] Can't open file") (Reader.read_file "wonderland")

let right_file _ = 
  (check (choice (list string))) "Compare strings" (Ok(test_content)) (Reader.read_file "res/Read_content.test")


(* General test suite *)
let suite = [
    "Wrong file", `Quick, wrong_file ;
     "Right file", `Quick, right_file ;
]
