(*
 * Module to provide a test for comment
 * DURAND-MARAIS © 2019
 *)
open Alcotest
open Core
open Utilitaries
open Monad

let good_json = Conf.init_json "res/good_comment.test"
let wrong_json = Conf.init_json "res/bad_comment.test"

let header = [
    "Hello"                       ;
    "I'm Luke"                    ;
    "You are my father"           ;
]

let compare_header_block = Ok ([
   "(**"                          ;
    "* Hello"                     ;
    "* I'm Luke"                  ;
    "* You are my father"         ;
    " *)"                         ;
])

let compare_header_inline = Ok ([
    "--> Hello"                   ;
    "--> I'm Luke"                ;
    "--> You are my father"       ;
])

let map = 
  good_json 
  >>= Comment.user_map


let good_format_block _ =
  let final_header = 
  map >>=  Comment.build_header header "mli" in
  check (choice (list string)) "Compare header with right format (block)"
  final_header compare_header_block

let good_format_inline _ =
  let final_header =
  map >>=  Comment.build_header header "np" in
  check (choice (list string)) "Compare header with right format (inline)"
  final_header compare_header_inline


let wrong_format _ = 
  let error = wrong_json >>= Comment.user_map in
  match error with 
  | Error str ->
      check (string) "Compare header with the wrong format"
      str "[Error] Block needs an array of strings"
  | _ -> raise Test_error


(* Test suite for formatter *)
let suite = [
  "Good ext format block", `Quick, good_format_block ;
  "Good ext format inline", `Quick, good_format_inline ;
  "Wrong ext format", `Quick, wrong_format
]
