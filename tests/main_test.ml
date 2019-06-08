open OUnit2

 let test_list = "Test list" >::: [
      Test_hello.suite
 ]

 let () =
   test_list |> run_test_tt_main  
