(*
 * Module to test FString
 * DURAND-MARAIS © 2019
 *)

open Alcotest
open Core.FString
open Utilitaries

(* Test center *)
let test_center_eq _ = 
  (check (choice string)) "center" 
    (Ok "  Center  ") (format_string (Some "center") (Some 10) "Center")

(* Test left *)
let test_left_eq _ =
  (check (choice string)) "left" 
    (Ok "Left  ") (format_string None (Some 6) "Left")

(* Test  right *)
let test_right_eq _ =
  (check (choice string)) "right" 
    (Ok "  Right") (format_string (Some "right") (Some 7) "Right")

(* Test bigger length *)
let test_outofbound _ =
  (check (choice string)) "out"
    (Ok "Bigger") (format_string None (Some 6) "Bigger string")

let test_pos_unknown _ =
  (check (choice string)) "unknown"
    (Error "[Error] Position unknown") (format_string (Some "above") None "Unknown")


(* Test suite for Hello *)
let suite = [
  "Center Position", `Quick, test_center_eq ;
  "Left Position", `Quick, test_left_eq     ;
  "Right Position", `Quick, test_right_eq   ;
  "Bigger String", `Quick, test_outofbound  ;
  "Unknown type", `Quick, test_pos_unknown  ;
]


