(*
 * Module to provide a test example
 * DURAND-MARAIS © 2019
 *)
open Alcotest
open Core

(* Lists to test *)

let example = [
  "Hello" ;
  "We are the eos project" ;
  "Welcome"
]

let false_list = [
  "Hello" ;
  "We are the eos project" ;
  "Welcme"
]

let shorter_list = [
  "Hello" ;
  "We are the eos project" ;
]

let longer_list = [
  "Hello" ;
  "We are the eos project" ;
  "Welcome" ;
  "Longer"
]


let test_list_eq _ =
  (check bool) "equal list" true
  (Comparator.compare example example)

let test_list_neq _ =
  (check bool) "non equal list" false
  (Comparator.compare example false_list)

let test_list_shorter _ =
  (check bool) "shorter list" false
  (Comparator.compare example shorter_list)


let test_list_longer _ =
  (check bool) "longer list" false
  (Comparator.compare example longer_list)


(* Test suite for Hello *)
let suite = [
  "List equality", `Quick, test_list_eq ;
  "List non equal", `Quick, test_list_neq ;
  "List shorter", `Quick, test_list_shorter ;
  "List longer", `Quick, test_list_longer ;
]


