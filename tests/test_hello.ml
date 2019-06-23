(*
 * Module to provide a test example 
 * DURAND-MARAIS © 2019
 *)
open Alcotest


(* Test if hello is equal hello *)
let test_hello_eq _ = 
  (check string) "equal Hello" "Hello" "Hello"


(* Test suite for Hello *)
let suite = [
    "Hello equality", `Quick, test_hello_eq
]


