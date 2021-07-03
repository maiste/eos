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

let compare l1 l2 =
  let rec compare_aux e1 e2 =
    match (e1, e2) with
    | ([], []) -> true
    | (h1 :: q1, h2 :: q2) -> if h1 = h2 then compare_aux q1 q2 else false
    | _ -> false
  in
  compare_aux l1 l2

let begin_of l1 l2 =
  let rec aux e1 e2 =
    match (e1, e2) with
    | (h1 :: q1, h2 :: q2) -> if h1 = h2 then aux q1 q2 else false
    | ([], _) -> true
    | _ -> false
  in
  aux l1 l2
