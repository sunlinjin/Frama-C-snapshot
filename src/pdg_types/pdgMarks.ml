(**************************************************************************)
(*                                                                        *)
(*  This file is part of Frama-C.                                         *)
(*                                                                        *)
(*  Copyright (C) 2007-2008                                               *)
(*    CEA   (Commissariat � l'�nergie Atomique)                           *)
(*    INRIA (Institut National de Recherche en Informatique et en         *)
(*           Automatique)                                                 *)
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
(*  See the GNU Lesser General Public License version v2.1                *)
(*  for more details (enclosed in the file licenses/LGPLv2.1).            *)
(*                                                                        *)
(**************************************************************************)

(* $Id: pdgMarks.ml,v 1.27 2008/04/01 09:25:21 uid568 Exp $ *)

(** This file provides useful things to help to associate an information
* (called mark) to PDG elements and to propagate it across the
* dependencies. 
*)

open PdgTypes
open PdgIndex

(** *)
let debug1() = Cmdline.Debug.get() >= 1
let debug2() = Cmdline.Debug.get() >= 2

type t_select_elem = SelNode of PdgTypes.Node.t | SelIn of Locations.Zone.t
type 'tm t_select = (t_select_elem * 'tm) list
type 'tm t_pdg_select = (PdgTypes.Pdg.t * 'tm t_select) list

type 'tm t_info_caller_inputs = (Signature.t_in_key * 'tm) list 

type 'tm t_info_called_outputs =
    (Cil_types.stmt * (Signature.t_out_key * 'tm) list) list

type 'tm t_info_inter = 'tm t_info_caller_inputs * 'tm t_info_called_outputs

let add_node_to_select select node m = (SelNode node, m)::select

let add_undef_in_to_select select loc m = 
  if (Locations.Zone.equal Locations.Zone.bottom loc) then select
  else (SelIn loc, m)::select

(** Type of the module that the user has to provide to describe the marks.  *)
module type T_Mark = sig
  type t
  type t_call_info

  val is_bottom : t -> bool

  val merge : t -> t -> t

  val combine : t -> t -> (t * t)

  val pretty : Format.formatter -> t -> unit
end


module type T_Fct = sig

  type t_mark
  type t_call_info
  type t_idx = (t_mark, t_call_info) PdgIndex.FctIndex.t

  type t = PdgTypes.Pdg.t * t_idx

  val create : PdgTypes.Pdg.t -> t
  val get_idx : t -> t_idx

  type t_mark_info_inter = t_mark t_info_inter

  val empty_to_prop : t_mark_info_inter

  val mark_and_propagate :
    t -> ?to_prop:t_mark_info_inter -> t_mark t_select -> 
    t_mark_info_inter
end


(** If the marks provided by the user respect some constraints (see [T_Mark]),
* we have that, after the marks propagation,
* the mark of a node are always smaller than the sum of the marks of its
* dependencies. It means that the mark of the statement [x = a + b;] 
* have to be smaller that the mark of [a] plus the mark of [b] at this point.
*
* If the marks are used for visibility for instance, 
* it means that if this statement is visible, 
* so must be the computation of [a] and [b], but [a] and/or [b] can be
* visible while [x] is not.
*)
module F_Fct (M : T_Mark) 
  : T_Fct with type t_mark = M.t 
           and type t_call_info = M.t_call_info
           and type t_idx = (M.t, M.t_call_info) FctIndex.t

= struct

  type t_mark = M.t
  type t_call_info = M.t_call_info
  type t_idx = (t_mark, t_call_info) FctIndex.t
  type t = Pdg.t * t_idx

  type t_mark_info_inter = t_mark t_info_inter

  let empty_to_prop = ([], [])

  let create pdg = (pdg, FctIndex.create 100)
                            (* TODO Pdg.get_index_size pdg *)

  let get_idx (_pdg, idx) = idx

  (** add the given mark to the node.
     @return [Some m] if [m] has to be propagated in the node dependencies,
             [None] otherwise.
   *)
  let add_mark _pdg fm node_key mark =
    if debug2 () then
      Format.printf "[pdgMark] add_mark %a -> %a @\n"
                    PdgIndex.Key.pretty node_key M.pretty mark ;
    let mark_to_prop =
      try
        begin (* simple node *)
          let new_mark, mark_to_prop =
            try
              let old_mark = FctIndex.find_info fm node_key in
              let new_m, m_prop = M.combine old_mark mark in
                (new_m, m_prop)
            with PdgIndex.NotFound -> (mark, mark)
          in FctIndex.add_or_replace fm node_key new_mark;
             mark_to_prop
        end
      with PdgIndex.CallStatement -> (* call statement *) assert false
    in mark_to_prop

  let add_in_to_to_prop to_prop in_key mark = 
    let rec add marks = match marks with 
      | [] -> [(in_key, mark)]
      | (k, m)::tl -> 
          let cmp = 
            try Signature.cmp_in_key in_key k 
            with PdgIndex.Not_equal -> 1 (* 2 <> InImpl -> insert after *)
          in
            if cmp = 0 then (in_key, M.merge m mark)::tl
            else if cmp < 0 then (in_key, mark) :: marks
            else (k, m)::(add tl)
    in
    let in_marks, out_marks = to_prop in
    let new_in_marks = add in_marks in
    new_in_marks, out_marks

  (** the new marks [to_prop] are composed of two lists :
  * - one [(in_key, mark) list] means that the mark has been added in the input,
  * - one [call, (out_key, m) list] that means that [m] has been added 
  * to the [out_key] output of the call.
  *
  * This function [add_to_to_prop] groups similar information,
  * and keep the list sorted.
  *)
  let add_to_to_prop to_prop key mark = 
    let rec add_out_key l key = match l with
      | [] -> [(key, mark)] 
      | (k, m) :: tl ->
          let cmp = 
            match key, k with 
            | Signature.OutLoc z, Signature.OutLoc zone ->
                if Locations.Zone.equal z zone then 0 else 1
            | _ -> Signature.cmp_out_key key k 
          in
            if cmp = 0 then (key, M.merge m mark)::tl
            else if cmp < 0 then (key, mark) :: l
            else (k, m)::(add_out_key tl key)
    in
    let rec add_out out_marks call out_key = match out_marks with
      | [] -> [ (call, [(out_key, mark)]) ]
      | (c, l)::tl ->
            if call.Cil_types.sid = c.Cil_types.sid 
            then (c, add_out_key l out_key)::tl
            else (c, l)::(add_out tl call out_key)
    in
      match key with
        | Key.SigCallKey (call, Signature.Out out_key) -> 
            let in_marks, out_marks = to_prop in
            let call = Key.call_from_id call in
            let new_out_marks = add_out out_marks call out_key in
              (in_marks, new_out_marks)
        | Key.SigKey (Signature.In in_key) -> 
            let to_prop = add_in_to_to_prop to_prop in_key mark in
              to_prop
        | _ -> (* nothing to do *) to_prop


  (** mark the nodes and their dependencies with the given mark.
  *  Stop when reach a node which is already marked with this mark. 
  * @return the modified marks of the function inputs,
  * and of the call outputs for interprocedural propagation.
  * *)
  let rec add_node_mark_rec get_dpds pdg fm node_marks to_prop =
    let mark_node_and_dpds to_prop (node, mark) =
      let node_key = PdgTypes.Node.elem_key node in
      let mark_to_prop = add_mark pdg fm node_key mark in
        if (M.is_bottom mark_to_prop) then
          begin
            if debug2 () then 
              Format.printf 
                "[pdgMark] mark_and_propagate = stop propagation !@\n";
            to_prop
          end
        else 
          begin
            if debug2 () then
              Format.printf "[pdgMark] mark_and_propagate = to propagate %a@\n"
                M.pretty mark_to_prop;
            let to_prop = add_to_to_prop to_prop node_key mark_to_prop in
            let dpds = get_dpds pdg node in
            let node_marks = List.map (fun n -> (n, mark_to_prop)) dpds in
              add_node_mark_rec get_dpds pdg fm node_marks to_prop
          end
    in List.fold_left mark_node_and_dpds to_prop node_marks

  let mark_and_propagate fm ?(to_prop=empty_to_prop) select =
    let pdg, idx = fm in
    let get_dpds = PdgTypes.Pdg.get_all_direct_dpds in
    let process to_prop (sel, mark) = match sel with
      | SelNode n -> add_node_mark_rec get_dpds pdg idx [(n, mark)] to_prop
      | SelIn loc ->
          let in_key = Key.implicit_in_key loc in
          let mark_to_prop = add_mark pdg idx in_key mark in
            if (M.is_bottom mark_to_prop) then to_prop
            else add_to_to_prop to_prop in_key mark_to_prop
    in
    let to_prop = List.fold_left process to_prop select in
      to_prop

end

module type T_Proj = sig
  type t
  type t_fct 
  type t_mark
  val empty : t
  val find_marks : t -> Cil_types.varinfo -> t_fct option
  val mark_and_propagate : 
             t -> PdgTypes.Pdg.t -> t_mark t_select -> unit
end

type 't_mark t_m2m =  t_select_elem -> 't_mark -> 't_mark option
type 't_mark t_call_m2m =  
    Cil_types.stmt -> PdgTypes.Pdg.t -> 't_mark t_m2m

module type T_Config = sig
  module M : sig
    include T_Mark
  end
  val mark_to_prop_to_caller_input : M.t t_call_m2m
  val mark_to_prop_to_called_output : M.t t_call_m2m
end

(*
Local Variables:
compile-command: "LC_ALL=C make -C ../.. -j"
End:
*)
