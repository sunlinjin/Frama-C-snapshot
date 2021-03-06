(**************************************************************************)
(*                                                                        *)
(*  This file is part of Frama-C.                                         *)
(*                                                                        *)
(*  Copyright (C) 2007-2017                                               *)
(*    CEA (Commissariat à l'énergie atomique et aux énergies              *)
(*         alternatives)                                                  *)
(*                                                                        *)
(*  you can redistribute it and/or modify it under the terms of the GNU   *)
(*  Lesser General Public License as published by the Free Software       *)
(*  Foundation, version 2.1.                                              *)
(*                                                                        *)
(*  It is distributed in the hope that it will be useful,                 *)
(*  but WITHOUT ANY WARRANTY; without even the implied warranty of        *)
(*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *)
(*  GNU Lesser General Public License for more details.                   *)
(*                                                                        *)
(*  See the GNU Lesser General Public License version 2.1                 *)
(*  for more details (enclosed in the file licenses/LGPLv2.1).            *)
(*                                                                        *)
(**************************************************************************)

open CilE
open Cil_types
open Locations

let do_warn {a_log; a_call} f =
  if a_log then f ();
  a_call ()

let warn_pointer_comparison typ warn_mode =
  let warn =
    match Value_parameters.WarnPointerComparison.get () with
    | "all" -> true
    | "none" -> false
    | "pointer" -> Cil.isPointerType typ
    | _ -> assert false
  in
  if warn then do_warn warn_mode.defined_logic (fun () -> ())

(* warn for division by 0. If [addresses] holds, also emit an alarm about the
   denominator not being comparable to \null. This is somewhat a hack, made
   mandatory because in the logic we are able to prove [&x + 2 != 0], with [x]
   having a non-array type. If we give a True status to such an assertion,
   no alarm remains for e.g. [1/((int)(&x +2))] .) *)
let warn_div warn_mode ~addresses =
  if addresses then begin
    (* Warn for the denominator not being comparable to Null *)
    do_warn warn_mode.defined_logic (fun () -> ())
  end;
  (* Warn for a null denominator *)
  do_warn warn_mode.others (fun () -> ())

let warn_integer_overflow warn_mode =
  do_warn warn_mode.others (fun () -> ())

let warn_float_to_int_overflow warn_mode =
  do_warn warn_mode.others (fun () -> ())

let warn_shift warn_mode =
  do_warn warn_mode.others (fun () -> ())

let warn_pointer_subtraction warn_mode =
  do_warn warn_mode.defined_logic (fun () -> ())

let warn_nan_infinite warn_mode =
  do_warn warn_mode.others (fun () -> ())

let warn_uninitialized warn_mode =
  do_warn warn_mode.unspecified (fun () -> ())

let warn_escapingaddr warn_mode =
  do_warn warn_mode.unspecified (fun () -> ())

let warn_mem warn_mode =
  do_warn warn_mode.others (fun () -> ())


let warn_locals_escape is_block fundec k locals =
  let pretty_base = Base.pretty in
  let pretty_block fmt = Pretty_utils.pp_cond is_block fmt "a block of " in
  let sv = fundec.svar in
  match locals with
  | Base.SetLattice.Top ->
      Value_util.warning_once_current
        "locals escaping the scope of %t%a through %a"
        pretty_block
        Printer.pp_varinfo sv
        pretty_base k
  | Base.SetLattice.Set _ ->
      Value_util.warning_once_current
        "locals %a escaping the scope of %t%a through %a"
        Base.SetLattice.pretty locals
        pretty_block
        Printer.pp_varinfo sv
        pretty_base k

let warn_imprecise_lval_read ~with_alarms lv loc contents =
  if with_alarms.imprecision_tracing.a_log then
  let pretty_gm fmt s =
    let s = Base.SetLattice.(inject (O.remove Base.null s)) in
    Base.SetLattice.pretty fmt s
  in
  let pretty_param fmt param =
    match param with
    | Base.SetLattice.Top -> Format.fprintf fmt "is imprecise"
    | Base.SetLattice.Set s ->
        Format.fprintf fmt "is a garbled mix of %a" pretty_gm s
  in
  let pretty_param_b fmt param =
    match param with
    | Base.SetLattice.Top ->
        Format.fprintf fmt "The contents@ are imprecise"
    | Base.SetLattice.Set s ->
          Format.fprintf fmt "It contains@ a garbled@ mix@ of@ %a" pretty_gm s
  in
  let something_to_warn =
    match loc.loc with
    | Location_Bits.Top _ -> true
    | Location_Bits.Map _ ->
      match contents with
      | Location_Bytes.Top _ -> true
      | Location_Bytes.Map _ -> false
  in
  if something_to_warn then do_warn with_alarms.imprecision_tracing
    (fun  () ->
    Value_parameters.result ~current:true ~once:true
      "@[<v>@[Reading left-value %a.@]@ %t%t%t@]"
      Printer.pp_lval lv
      (fun fmt ->
         match loc.loc with
         | Location_Bits.Top (param,o) when Origin.equal o Origin.top  ->
           Format.fprintf fmt "@[The location %a.@]@ "
             pretty_param param
         | Location_Bits.Top (param,orig) ->
           Format.fprintf fmt "@[The location @[%a@]@ because of@ %a.@]@ "
             pretty_param param
             Origin.pretty orig
         | Location_Bits.Map _ ->
           match lv with
           | Mem _, _ ->
             Format.fprintf fmt "@[The location is @[%a@].@]@ "
               Location_Bits.pretty loc.loc
           | Var _, _ -> ()
      )
      (fun fmt ->
         match contents with
         | Location_Bytes.Top (param,o) when Origin.equal o Origin.top ->
                 Format.fprintf fmt "@[%a.@]"
                   pretty_param_b param
         | Location_Bytes.Top (param,orig) ->
             Format.fprintf fmt "@[%a@ because of@ %a.@]"
               pretty_param_b param
               Origin.pretty orig
         | Location_Bytes.Map _ -> ())
      Value_util.pp_callstack)

(* Auxiliary function for [do_assign] below. When computing the
   result of [lv = exp], warn if the evaluation of [exp] results in
   an imprecision. [loc_lv] is the location pointed to by [lv].
   [exp_val] is the part of the evaluation of [exp] that is imprecise. *)
let warn_right_exp_imprecision ~with_alarms lv loc_lv exp_val =
  do_warn with_alarms.imprecision_tracing
    (fun () ->
       match exp_val with
         | Location_Bytes.Top(_topparam,origin) ->
             Value_parameters.result ~once:true ~current:true
               "@[<v>@[Assigning imprecise value to %a%t.@]%a%t@]"
               Printer.pp_lval lv
               (fun fmt -> match lv with
                  | (Mem _, _) ->
                    Format.fprintf fmt "@ (pointing to %a)"
                      (Locations.pretty_english ~prefix:false) loc_lv
                  | (Var _, _) -> ())
               (fun fmt org ->
                  if not (Origin.is_top origin) then
                    Format.fprintf fmt
                      "@ @[The imprecision@ originates@ from@ %a@]"
                      Origin.pretty org)
               origin
               Value_util.pp_callstack
         | Location_Bytes.Map _ -> ())

let warn_float ~with_alarms ?(non_finite=false) ?(addr=false) () =
  if addr || non_finite then
    warn_nan_infinite with_alarms;
;;

let warn_top () =
  Value_parameters.abort ~current:true ~once:true
    "completely imprecise state during evaluation. Aborting."


(*
Local Variables:
compile-command: "make -C ../../../.."
End:
*)
