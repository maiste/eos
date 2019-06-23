(*
 * Test main module 
 * DURAND-MARAIS © 2019
 *) 


let test_core = [
  "Hello", Test_hello.suite ;
  "Reader", Test_reader.suite ;
  "Finder", Test_finder.suite
]


let () =
  Alcotest.run "Eos tests" test_core

