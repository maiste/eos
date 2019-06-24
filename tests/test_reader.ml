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
  "For the livings!" ;
  ""
]

let wrong_file _ = 
   (check (option (list string)))
      "Check wrong file" None (Reader.read_file "Wonderland")


let right_file _ = 
  let file = Reader.read_file "res/Read_content.test" in
  match file with
  | None ->  raise Test_error
  | Some content -> 
      (check (list string)) "Compare strings" content test_content
      



(* General test suite *)
let suite = [
    "Wrong file", `Quick, wrong_file ;
     "Right file", `Quick, right_file ;
]
