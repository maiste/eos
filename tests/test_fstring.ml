(*
 * Module to test FString
 * DURAND-MARAIS © 2019
 *)

open Alcotest
open Core.FString

(* Test center *)
let test_center_eq _ = 
  (check string) "center" 
  "  Center  " (format_string 10 "Center")

(* Test left *)
let test_left_eq _ =
  (check string) "left" 
  "Left  " (format_string ~pos:Left 6 "Left")

(* Test  right *)
let test_right_eq _ =
  (check string) "right" 
  "  Right" (format_string ~pos:Right 7 "Right")

(* Test bigger length *)
let test_outofbound _ =
  (check string) "out"
  "Bigger" (format_string 6 "Bigger string")

(* Test suite for Hello *)
let suite = [
  "Center Position", `Quick, test_center_eq ;
  "Left Position", `Quick, test_left_eq     ;
  "Right Position", `Quick, test_right_eq   ;
  "Bigger String", `Quick, test_outofbound  ;
]


