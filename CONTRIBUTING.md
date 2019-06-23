## Contributor guideline

### Contribution :

0) Create an issue with the label `feature` and verify that a similar issue is not already open.

1) Create a new branch with the name of the new feature in your fork (or the current repository if you are a code owner).

2) Add a test file ```<feature>_test.ml``` in the ```tests/``` directory with your test suite function (Alcotest). Add this function to the list in 
`main_test.ml`. If you modify an already existing file, just add tests to the existing suite associated with.
Only PR that passed tests will be accepted.
*Example*: 

```
  (* newfeature_test.ml *)
  open Alcotest
  
  let test_newfeature1 = 
    (check string) "Hello eq" "Hello" "Hello"

   let test_newfeature2 =  
    (check int) "Int eq" 1 1
  
  let suite = [ 
      "Feature1", `Quick, test_newfeature1 ;
      "Feature2", `Quick, test_newfeature2 ;
    ]


  (* main_test.ml *)
  
  let test_core = [
      "Newfeature", Newfeature_test.suite
    ]
  
  let () = 
      Alcotest.run "Eos tests" test_core
```

3) Create a Pull request into ```dev``` with a reference to your issue number. Be 100% proud of the work you push. It means a clean history (one 
commit = one block of modification) where each commit name is written following the current example: 

```sh
  $ git commit -S -m "<feature>: Verb modifications"
```

4) Wait for reviewing

### Report bugs

0) Create an issue and verify that a similar issue is not already open.

1) Add as much information as you can

2) Stay cool and polite

### Branches
* ```master``` correspond to the stable release.
* ```dev``` is the branch where **eos** is developed. Every PR is into it.
* ```<feature>``` is the branch where you add a new feature.
* ```patch_v<VERSION>.<PATCH>``` is a branch with a correction for master.


