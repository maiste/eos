(* 
 * Test for the reader module 
 * DURAND - MARAIS © 2019
 *)

open OUnit2
open Core

(* File original content *)
let test_content = [
  "Luke, I'm your father" ;
  "42 is the answer" ;
  "I never know if Sally tried to protect me" ;
  "For the livings!" ;
  ""
]

(* Compare two contents *)
let rec compare_files f1 f2 = 
  match f1, f2 with 
  | [], [] -> assert_bool "OK" true
  | h1::q1, h2::q2 ->
      if h1 = h2 then compare_files q1 q2
      else  assert_bool "FAILED" false
  | _,_ -> assert_bool "FAILED X" false 



let wrong_file _ = 
  let () = Printf.printf "Wrong file\n" in
  assert_equal None (Reader.read_file "Wonderland")

let right_file _ = 
  let () = Printf.printf "Right file\n" in
  let file = Reader.read_file "res/Read_content.test" in
  match file with
  | None -> assert_bool "FAILED" false
  | Some content -> compare_files content test_content 



(* General test suite *)
let suite = "Test Reader" >:::
  [
    "Wrong file" >:: wrong_file ;
     "Right file" >:: right_file (* Need to create a recursive copy *)
  ]
