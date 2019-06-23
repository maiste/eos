(*
 * Module to provide a test example 
 * DURAND-MARAIS © 2019
 *)
open Alcotest
open Core

let test_bank =
  [
    [".*\\.ml"; "banana"];
    [".*"];
    [""];
    ["echec"];
    ["\\..*"];
    ["src/"];
    ["./src"]
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

(* Split of [str] by '\n' *)
let decomp str = String.split_on_char '\n' str

(* Execution of the finder command *)
let finder_cmd rgxl =
  let rec aux acc l =
    match l with
    | [] -> acc
    | h :: q -> aux (acc ^ " -e \"" ^ h ^ "\"") q 
  in
  let cmd = aux "find -type f | grep -e \"^$\"" rgxl in
  let call_cmd = syscall cmd in
  decomp call_cmd



(* Test if finder works correctly *)
let test_finder_eq _ = 
  let rec aux l turn =
    match l with
    | [] -> ()
    | h :: q -> 
      let res_cmd = List.sort compare (finder_cmd h) in
      let res_finder = List.sort compare ("" :: Finder.get_all_files h) in
      (check (list string)) ("equal list " ^ (string_of_int turn)) res_cmd res_finder;
      aux q (turn + 1)
  in
  aux test_bank 0


(* Test suite for Finder *)
let suite = [
  "List finder equality", `Slow, test_finder_eq
]


