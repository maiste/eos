open OUnit2

 let test_list = "Test list" >::: [
   Test_hello.suite ;
   Test_reader.suite
 ]

 let () =
   test_list |> run_test_tt_main  
