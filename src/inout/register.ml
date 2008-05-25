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

(* $Id: register.ml,v 1.5 2008/04/01 09:25:20 uid568 Exp $ *)

let () =
  Options.add_plugin 
    ~name:"inout (experimental)" 
    ~descr:"analysis of inputs and outputs of functions"
    [ Context.option; Inputs.option; Outputs.option; Derefs.option;
      Access_path.option ]

(*
Local Variables:
compile-command: "LC_ALL=C make -C ../.. -j"
End:
*)
