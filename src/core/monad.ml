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

type 'a choice = ('a, string) result

(* Bind for 'a choice. *)
let ( >>= ) obj f = match obj with Ok a -> f a | Error b -> Error b

(* Clear bind. *)
let ( let* ) = ( >>= )

(* Apply function corresponding to [List.map f l] where [f] is a
   [('a -> 'b choice)] function and [l] is a ['a list]. Return a
   ['b list choice]. *)
let map_choice_list f l =
  let nl =
    List.fold_left
      (fun a b ->
        a >>= fun acc ->
        f b >>= fun res -> Ok (res :: acc))
      (Ok [])
      l
  in
  nl >>= fun l -> Ok (List.rev l)

(* Bind for option. *)
let ( >== ) obj f = match obj with Some a -> f a | None -> None

let ( let+ ) = ( >== )

(* From monad option to monad choice. *)
let opt_to_choice str_error obj =
  match obj with Some a -> Ok a | None -> Error str_error

(* From 'a to 'a choice. *)
let choice value = Ok value
