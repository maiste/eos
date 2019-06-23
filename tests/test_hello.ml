open OUnit2

(* Test if hello is equal hello *)
let test_hello_eq _ = 
  let () = Printf.printf "Hello\n" 
  in assert_equal "Hello" "Hello"

(* Test suite for Hello *)
let suite = "Test Hello" >::: 
  [
    "Hello" >:: test_hello_eq
  ]


