## Contributor guideline

### Contribution :

0) Create an issue with the label feature and verify that a similar issue isn't already open.
1) Create a new branch with the name of the new feature in your fork (or the current repository if you are a code owner).
2) Add a test file <feature>_test.ml in the ```tests/``` directory with your test suite function (OUnit). Add this function to the list in 
```main_test.ml```. If you modify an already existing file, just add tests to the existing suite associated with the file you modify.
Only PR that passed tests will be accepted.

*Example* : 
```ocaml
  (* newfeature.ml *)
  open OUnit2
  
  let test_newfeature1 = 
    let ()  = Printf.printf "Feature1" in 
    assert_equal 1 1
    
   let test_newfeature2 = 
    let ()  = Printf.printf "Feature2" in 
    assert_equal 1 1
  
  let suite = "Test newfeature" >:::
    [ 
      "Feature1" >::: test_newfeature1 ;
      "Feature2" >::: test_newfeature2 
    ]


  (* main_test.ml *)
  open OUnit2
  
  let test_list = "Test_list" >:::
    [
      Newfeature.suite
    ]
  
  let () = runt_test_tt_main test_list

```

2) Create a Pull request into **dev** with a reference to your issue number. Be 100% happy with the work you push. It means a clean history (one 
commit = one block of modification) where each commit name is written following the current example : 
```sh
  $ git commit -S -m "<feature>: Verb modifications"
```
3) Wait for reviewing

### Report bugs

0) Create an issue and verify that a similar issue isn't already open.
1) Add as much information as you can
2) Stay cool and polite

### Branches
* Master correspond to the stable realease
* Dev is the branch where eos is developed. Every PR is into it.
* <feature> is the branch where you add new feature
* patch_v<VERSION>.<PATCH> is a branch with a correction for master


