(**************************************************************************)
(*                                                                        *)
(*  Copyright (C) 2001-2003,                                              *)
(*   George C. Necula    <necula@cs.berkeley.edu>                         *)
(*   Scott McPeak        <smcpeak@cs.berkeley.edu>                        *)
(*   Wes Weimer          <weimer@cs.berkeley.edu>                         *)
(*   Ben Liblit          <liblit@cs.berkeley.edu>                         *)
(*  All rights reserved.                                                  *)
(*                                                                        *)
(*  Redistribution and use in source and binary forms, with or without    *)
(*  modification, are permitted provided that the following conditions    *)
(*  are met:                                                              *)
(*                                                                        *)
(*  1. Redistributions of source code must retain the above copyright     *)
(*  notice, this list of conditions and the following disclaimer.         *)
(*                                                                        *)
(*  2. Redistributions in binary form must reproduce the above copyright  *)
(*  notice, this list of conditions and the following disclaimer in the   *)
(*  documentation and/or other materials provided with the distribution.  *)
(*                                                                        *)
(*  3. The names of the contributors may not be used to endorse or        *)
(*  promote products derived from this software without specific prior    *)
(*  written permission.                                                   *)
(*                                                                        *)
(*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS   *)
(*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT     *)
(*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS     *)
(*  FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE        *)
(*  COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,   *)
(*  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,  *)
(*  BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;      *)
(*  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER      *)
(*  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT    *)
(*  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN     *)
(*  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE       *)
(*  POSSIBILITY OF SUCH DAMAGE.                                           *)
(*                                                                        *)
(*  File modified by CEA (Commissariat � l'�nergie Atomique).             *)
(**************************************************************************)

open Cil_types
let gcc = {
  (* Hand-crafted Diab-C compiler *)
	 version_major    = 4;
	 version_minor    = 4;
	 version          = "4.4 (Diab-C Windriver)";
	 sizeof_short     = 2;
	 sizeof_int       = 4;
	 sizeof_long      = 4;
	 sizeof_longlong  = 8;
	 sizeof_ptr       = 4;
	 sizeof_enum      = 4;
	 sizeof_float     = 4;
	 sizeof_double    = 8;
	 enum_are_signed  = true;
	 sizeof_longdouble  = 8;
	 sizeof_void      = 0;
	 sizeof_fun       = 0;
	 size_t = "unsigned long";
	 wchar_t = "int";
	 ptrdiff_t = "int";
	 alignof_short = 2;
	 alignof_int = 4;
	 alignof_long = 4;
	 alignof_longlong = 8;
	 alignof_ptr = 4;
	 alignof_enum = 4;
	 alignof_float = 4;
	 alignof_double = 8;
	 alignof_longdouble = 8;
	 alignof_str = 4;
	 alignof_fun = 0;
	 alignof_char_array = 1;
	 char_is_unsigned = true;
	 const_string_literals = false;
	 little_endian = false;
	 underscore_name = false ;
}
let hasMSVC = false
let msvc = gcc 
let gccHas__builtin_va_list = false
let __thread_is_keyword = false
