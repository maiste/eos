(**********************************************************************************)
(* MIT License                                                                    *)
(*                                                                                *)
(* Copyright (c) 2019 Étienne Marais <etienne@maiste.fr>                          *)
(* Copyright (c) 2019 Xavier Durand <xavier75013@gmail.com>                       *)
(*                                                                                *)
(* Permission is hereby granted, free of charge, to any person obtaining a copy   *)
(* of this software and associated documentation files (the "Software"), to deal  *)
(* in the Software without restriction, including without limitation the rights   *)
(* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      *)
(* copies of the Software, and to permit persons to whom the Software is          *)
(* furnished to do so, subject to the following conditions:                       *)
(*                                                                                *)
(* The above copyright notice and this permission notice shall be included in all *)
(* copies or substantial portions of the Software.                                *)
(*                                                                                *)
(* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     *)
(* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       *)
(* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    *)
(* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER         *)
(* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  *)
(* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  *)
(* SOFTWARE.                                                                      *)
(**********************************************************************************)

open Cmdliner
open Monad

let name = "eos"

let version = "0.1"

let licence = "MIT"

let description =
  "a simple header manager for your projects.\n\
   It allows you to manage header in one single JSON file and automatize many \
   features."

let homepage = "https://github.com/maiste/eos"

let bug_reports = "https://github.com/maiste/eos/issues"

let dev_repo = "git://github.com/maiste/eos.git"

let authors =
  [ "Etienne (Maiste) Marais <etienne@maiste.fr>";
    "Xavier (Xavitator) Durand <xavier75013@gmail.com>"
  ]

let man =
  let bug = [ `S Manpage.s_bugs; `P ("Report bug : " ^ bug_reports) ] in
  let author =
    List.fold_left
      (fun a b -> a @ [ `P b; `Noblank ])
      [ `S Manpage.s_authors ]
      authors
  in
  let contribution =
    [ `S "CONTRIBUTION";
      `P ("$(b,Licence) : " ^ licence);
      `P ("$(b,Homepage) : " ^ homepage);
      `P ("$(b,Dev repository) : " ^ dev_repo)
    ]
  in
  bug @ contribution @ author

let prompt_list l = List.iter (Printf.printf "%s\n") l

let get_files () =
  match
    Conf.init_json Conf.conf_file >>= Conf.get_file_regex >>= Finder.get_files
  with
  | Ok l -> Ok (prompt_list l)
  | Error msg -> Error (`Msg msg)

(* Show the current header *)
let show_header () =
  let user = Conf.init_json Conf.conf_file in
  let template = user >>= Conf.get_template_json in
  match (user, template) with
  | (Ok u, Ok t) -> (
      match Formatter.formatter t u with
      | Ok s ->
          Ok
            (Printf.printf "This is the current header with your conf:\n%s\n" s)
      | Error msg -> Error (`Msg msg))
  | (Error msg, _) -> Error (`Msg msg)
  | (_, Error msg) -> Error (`Msg msg)

let update_files verbose confirm =
  match Update.update_all verbose confirm with
  | Ok l -> Ok l
  | Error msg -> Error (`Msg msg)

(* Command corresponding to 'eos files'. *)
let files =
  let doc = "display files tracked by eos." in
  let exits = Term.default_exits in
  ( Term.(term_result (const get_files $ const ())),
    Term.info "files" ~doc ~exits ~man )

let show =
  let doc = "display the header." in
  let exits = Term.default_exits in
  ( Term.(term_result (const show_header $ const ())),
    Term.info "show" ~doc ~exits ~man )

let update =
  let confirm =
    let doc = "Ask for modification on all files with [y/n] questions." in
    Arg.(value & flag & info [ "c"; "confirm" ] ~doc)
  in
  let verbose =
    let doc = "Display all changed files." in
    Arg.(value & flag & info [ "v"; "verbose" ] ~doc)
  in
  let doc = "Put new template in files." in
  let exits = Term.default_exits in
  ( Term.(term_result (const update_files $ verbose $ confirm)),
    Term.info "update" ~doc ~exits ~man )

(* Default command if no command is matched. *)
let default =
  let exits = Term.default_exits in
  ( Term.(ret (const (`Help (`Pager, None)))),
    Term.info name ~version ~doc:description ~exits ~man )

(* List of all eos' command. *)
let cmds = [ files; show; update ]

let run () = Term.(exit ~term_err:1 @@ eval_choice default cmds)
