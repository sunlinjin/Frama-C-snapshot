(**************************************************************************)
(*                                                                        *)
(*  This file is part of Frama-C.                                         *)
(*                                                                        *)
(*  Copyright (C) 2007-2008                                               *)
(*    CEA (Commissariat � l'�nergie Atomique)                             *)
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

(* $Id: subst.mli,v 1.6 2008/04/01 09:25:21 uid568 Exp $ *)

(** Substitution of varinfos by exps *)

open Cil_types

type t
  (** Type of the substitution. *)

val empty: t
  (** The empty substitution. *)

val add: varinfo -> exp -> t -> t
  (** Add a new couple to the substitution. *)

val remove: varinfo -> t -> t
  (** Do not substitute the varinfo anymore. *)

val expr: ?trans:bool -> exp -> t -> exp * bool
  (** Apply the substitution to an expression.
      If [trans], the substitution is transitively applied. Default is [true].
      For example, with subst = \{ x -> &y; y -> b \} and exp = x, the result 
      is &b by default and &y if trans is false.
      The returned boolean flag is true is a substitution occured. *)

val lval: ?trans:bool -> lval -> t -> exp * bool
  (** Apply the substitution to a lvalue. *)
