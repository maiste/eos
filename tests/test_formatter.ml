(*
 * Module to provide a test example for formatter 
 * DURAND-MARAIS © 2019
 *)
open Alcotest
open Core
open Utilitaries
open Monad


let mustache_1 = Ok (Mustache.of_string "{{subject}} {{verb}} that's working.\nIt is {{adj}}.")
let user_conf_1 = Ezjsonm.from_string 
    "{
  \"template\" : {
    \"subject\" : \"I\",
    \"verb\" : \"believe\",
    \"adj\" : \"cool\"
  }
}"
let attempt_res_1 = "I    believe    that's working.\nIt is cool."

let mustache_2 = Ok (Mustache.of_string "Test list {{name}} : {{# list}} {{name}} {{/list}}.")
let user_conf_2 = Ezjsonm.from_string 
    "{
  \"template\" : {
    \"name\" : \"eos\",
    \"list\" : [
      {\"name\" : \"name1\"},
      {\"name\" : \"name2\"}
    ]
  }
}"
let attempt_res_2 = "Test list eos        :       name1       name2 ."

let template_res = 
  [
    ("formatter_content1.test", mustache_1, user_conf_1, Ok(attempt_res_1));
    ("formatter_content2.test", mustache_2, user_conf_2, Ok(attempt_res_2))
  ]

let test_get_template _ =
  List.iter 
    (fun (a, b, _,_) -> 
       let json = Conf.init_json ("res/"^a) in
       (check (choice_str Mustache.to_string)) ("get_template on "^a) b (json >>= Formatter.get_template)
    )
    template_res

let test_formatter _ =
  List.iter 
    (fun (a, _, c, d) -> 
       let json = Conf.init_json ("res/"^a) in
       (check (choice string)) 
         ("formatter on "^a) 
         d 
         (match json with 
          | Ok js -> Formatter.formatter js c
          | Error e -> Error e)

    )
    template_res

(* Test suite for formatter *)
let suite = [
  "Getter of mustache template", `Quick, test_get_template;
  "Test formatter function", `Quick, test_formatter
]