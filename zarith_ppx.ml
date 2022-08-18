open Ppxlib

module Stre = Str
open Ast_helper

(* Location.error_extensionf that also wraps in Exp.extension *)
let error ppf =
  Format.kasprintf (fun s ->
    let loc = !default_loc in
    Exp.extension ~loc @@
    Location.Error.to_extension @@
    Location.Error.make ~loc s ~sub:[])
    ppf

let mklid m lid =
  Exp.ident
    {Location.loc = !default_loc ; txt = Longident.(Ldot (Lident m, lid))}
let app m lid l =
  Exp.(apply (mklid m lid)
      (List.map (fun e -> Asttypes.Nolabel, e) l))

let integer m s =
  let x = Z.of_string s in
  if x = Z.zero then mklid m "zero"
  else if x = Z.one then mklid m "one"
  else if x = Z.minus_one then mklid m "minus_one"
  else if Z.numbits x < 31 then
    app m "of_int" [Exp.constant @@ Const.int @@ Z.to_int x]
  else if Z.fits_int32 x then
    app m "of_int32" [Exp.constant @@ Const.int32 @@ Z.to_int32 x]
  else if Z.fits_int64 x then
    app m "of_int64" [Exp.constant @@ Const.int64 @@ Z.to_int64 x]
  else app m "of_string" [Exp.constant @@ Const.string s]

let integer_z = integer "Z"
let integer_q = integer "Q"

(* When the programmer writes 9007199254740993.0q, they want the rational for
   9007199254740993, not for the closest double-precision number to that
   9007199254740992.
   Similarly, when the programmer writes 0.1q, they want the rational for 1/10,
   not for 1000000000000000055511151231257827021181583404541015625/10000000000000000000000000000000000000000000000000000000.
   For all these reasons float_of_string must not be used here.

   Instead we use a regular expression to get the pieces and recombine them.
   The format is I.FeX
   We produce I * 10^E + F * 10^k where k = E - |F|

   This fits in an integer if E >= |F|
*)

let re = Stre.regexp_case_fold
    {|^\(-?\)\([0-9]+\)\(\.\([0-9]+\)?\)?\(e\([+-]?[0-9]+\)\)?$|}
let match_float s =
  if Stre.string_match re s 0 then
    let sign = Stre.matched_group 1 s = "" in
    let i = Stre.matched_group 2 s in
    let f =
      try Some (Stre.matched_group 4 s)
      with Not_found -> None in
    let e =
      try int_of_string @@ Stre.matched_group 6 s
      with Not_found -> 0 in
    Some (sign, i, e, f)
  else
    None

let ten = app "Z" "of_int" [Exp.constant @@ Const.int 10]
let e10 n = app "Z" "pow" [ten; Exp.constant @@ Const.int n]
let add m = app m "add"
let neg_if b m x = if b then x else app m "neg" [x]

let mul_10exp a n =
  if n = 0 then `Z a
  else if n < 0 then `Q (app "Q" "make" [a; e10 (-n)])
  else `Z (app "Z" "mul" [a; e10 n])
let addx a b = match a,b with
  | `Z a, `Z b -> `Z (add "Z" [a;b])
  | `Z a, `Q b | `Q b, `Z a ->`Q (add "Q" [app "Q" "of_bigint" [a]; b])
  | `Q a, `Q b -> `Q (add "Q" [a;b])

let make_float i e f =
  let a = mul_10exp (integer_z i) e in
  match f with
  | None -> a
  | Some f ->
    let b = mul_10exp (integer_z f) (e - String.length f) in
    addx a b

let is_float_exa s =
  String.length s >= 2 &&
  let pre = String.sub s 0 2 in
  pre = "0x" || pre = "0X"
let fail_exa () =
  error "%a" Format.pp_print_text
    "Hexadecimal floating point numbers are not accepted. \
     Please use hexadecimal integers, or regular floating point numbers."

let float_z s =
  if is_float_exa s then fail_exa ()
  else match match_float s with
    | None -> error "This literal is not a valid zarith integer."
    | Some (pos, i, e, f) ->
      match make_float i e f with
      | `Q _ -> error "This literal does not fit in an integer. You should use a rational number."
      | `Z z -> neg_if pos "Z" z

let float_q s =
  if is_float_exa s then fail_exa ()
  else match match_float s with
    | None -> error "This literal is not a valid zarith rational number."
    | Some (pos, i, e, f) ->
      neg_if pos "Q" @@ match make_float i e f with
      | `Q q -> q
      | `Z z -> app "Q" "of_bigint" [z]

let expander f loc s =
  with_default_loc loc @@ fun () -> f s

(** Register the rewriter in the driver *)
let () =
  Driver.register_transformation
    "zarith-ppx"
    ~rules:[
      Context_free.Rule.constant Integer 'z' (expander integer_z);
      Context_free.Rule.constant Float 'z' (expander float_z);
      Context_free.Rule.constant Integer 'q' (expander integer_q);
      Context_free.Rule.constant Float 'q' (expander float_q);
    ]

(*
 * Copyright (c) 2019 Gabriel Radanne <drupyog@zoho.com>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *)
