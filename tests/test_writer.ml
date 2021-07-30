(*
 * Module to test writer.ml
 * DURAND-MARAIS © 2019
 *)

open Alcotest
open Eos_core
open Utilitaries

let content = [
  "I'm the content" ;
  "How are you?" ;
  "Fine!" ;
  "" ;
]

(* Test if hello is equal hello *)
let test_writer_ok _ =
  let res = Writer.write "res/writer.test" content in
  (check (choice bool)) "writer ok" (Ok true) res

let test_writer_content _ = 
 (check (choice (list string))) "Writer content"
 (Ok content) (Reader.read_file "res/writer.test")

(* Test suite for Hello *)
let suite = [
  "Write OK", `Quick, test_writer_ok ;
  "Write content", `Quick, test_writer_content
]


