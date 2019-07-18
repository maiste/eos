(*
 * Test main module 
 * DURAND-MARAIS © 2019
 *) 


let test_core = [
  "Hello", Test_hello.suite         ;
  "Reader", Test_reader.suite       ;
  "Finder", Test_finder.suite       ;
  "Conf", Test_conf.suite           ;
  "FString", Test_fstring.suite     ;
  "Formatter", Test_formatter.suite ;
]


let () =
  Alcotest.run "Eos tests" test_core

