(*
 * Module to provide a test example 
 * DURAND-MARAIS © 2019
 *)
open Eos_core

let test_bank =
  [
    [".*\\.ml"; "banana"];
    ["res/.*"];
    [""];
    ["echec"];
    ["src/"];
    ["./src"];
    [];
  ]

(* Function to call a system command and recover the exit *)
let syscall cmd =
  let ic, oc = Unix.open_process cmd in
  let buf = Buffer.create 16 in
  (try
     while true do
       Buffer.add_channel buf ic 1
     done
   with End_of_file -> ());
  let _ = Unix.close_process (ic, oc) in
  (Buffer.contents buf)

open Alcotest (* Avoid conflict name *)

(* Split of [str] by '\n' *)
let decomp str = String.split_on_char '\n' str

(* Execution of the finder command *)
let finder_cmd rgxl =
  let rec aux acc l =
    match l with
    | [] -> acc
    | h :: q ->
        if h <> "" then
          aux (acc ^ " -e \"" ^ h ^ "\"") q
        else
          aux acc q
  in
  let cmd = aux "find -type f | grep -e \"^$\"" rgxl in
  let call_cmd = syscall cmd in
  decomp call_cmd


(* Test if finder works correctly *)
let test_finder_eq _ = 
  let aux turn h =
    let res_cmd = List.sort compare (finder_cmd h) in
    let res_finder = match Finder.get_files h with 
      | Ok content -> List.sort compare (""::content)
      | Error str -> [""]
    in 
    (check (list string)) 
      ("equal list " ^ (string_of_int turn)) res_cmd res_finder
  in
  List.iteri aux test_bank

let name_test_finder = 
  "List finder equality : " ^
  (string_of_int (List.length test_bank)) ^
  " subtests"

(* Test suite for Finder *)
let suite = [
  name_test_finder, `Slow, test_finder_eq
]


