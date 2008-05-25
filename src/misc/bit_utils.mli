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

(* $Id: bit_utils.mli,v 1.7 2008/04/01 09:25:21 uid568 Exp $ *)

(** Some bit manipulations. *)

open Cil_types

val sizeofchar: unit -> My_bigint.big_int
  (** [sizeof(char)] in bits *)

val sizeofpointer: unit -> int
  (** [sizeof(char* )] in bits *)

val memory_size: unit -> My_bigint.big_int

val sizeof: typ -> Int_Base.t
  (** [sizeof ty] is the size of [ty] in bits. This function may return
      [Int_Base.top]. *)

val osizeof: typ -> Int_Base.t
  (** [osizeof ty] is the size of [ty] in bytes. This function may return
      [Int_Base.top]. *)
  
exception Neither_Int_Nor_Enum_Nor_Pointer

val is_signed_int_enum_pointer: typ -> bool
  (** [true] means that the type is signed.  
      @raise Neither_Int_Nor_Enum_Nor_Pointer if the sign of the type is not
      meaningful. *)

val signof_typeof_lval: lval -> bool
  (** Returns the sign of type of the [lval]. [true] means that the type is
      signed. *)

val sizeof_vid: varinfo -> Int_Base.t
  (** Returns the size of a the type of the variable in bits. *)

val sizeof_lval: lval -> Int_Base.t
  (** Returns the size of a the type of the variable in bits. *)

val sizeof_pointed: typ -> Int_Base.t
  (** Returns the size of the type pointed by a pointer or array type in bits.
      Never call it on a non pointer or non array type . *)

val osizeof_pointed: typ -> Int_Base.t
  (** Returns the size of the type pointed by a pointer or array type in bytes.
      Never call it on a non pointer or array type. *)

val sizeof_pointed_lval: lval -> Int_Base.t
  (** Returns the size of the type pointed by a pointer type of the [lval] in
      bits. Never call it on a non pointer type [lval]. *)

val typeOf_pointed : typ -> typ
  (** Returns the type pointed by the given type. Asserts it is a pointer
      type. *)

val is_fully_arithmetic: typ -> bool
  (** Returns [true] whenever the type contains only arithmetic types *)

(** {2 Pretty printing} *)

val pretty_bits: 
  typ -> 
  use_align:bool ->
  align:My_bigint.big_int ->
  rh_size:My_bigint.big_int ->
  start:My_bigint.big_int ->
  stop:My_bigint.big_int -> string * bool
  (** Pretty prints a range of bits in a type for the user.
      Tries to find field names and array indexes, whenever possible. *)

(*
Local Variables:
compile-command: "make -C ../.."
End:
*)
