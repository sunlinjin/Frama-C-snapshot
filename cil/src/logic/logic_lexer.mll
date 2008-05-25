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

{

  open Logic_parser
  open Lexing
  open Logic_ptree

  type state = Normal | Test

  let state_stack = Stack.create ()

  let () = Stack.push Normal state_stack

  let get_state () = try Stack.top state_stack with Stack.Empty -> Normal

  let pop_state () = try ignore (Stack.pop state_stack) with Stack.Empty -> ()

  exception Error of (int * int) * string

  let loc lexbuf = (lexeme_start lexbuf, lexeme_end lexbuf)

  let lex_error lexbuf s =
    raise (Error (loc lexbuf, "lexical error, " ^ s))

  let find_utf8 =
    let h = Hashtbl.create 97 in
    List.iter (fun (i,t) -> Hashtbl.add h i t)
      [ Utf8_logic.forall, FORALL;
        Utf8_logic.exists, EXISTS;
        Utf8_logic.eq, EQ;
        Utf8_logic.neq, NE;
        Utf8_logic.le, LE;
        Utf8_logic.ge, GE;
        Utf8_logic.implies,IMPLIES;
        Utf8_logic.iff, IFF;
        Utf8_logic.conj, AND;
        Utf8_logic.disj, OR;
        Utf8_logic.neg, NOT;
        Utf8_logic.x_or, HATHAT;
      ];

    fun s -> try Hashtbl.find h s
    with Not_found -> IDENTIFIER s

  let identifier =
    let all_kw = Hashtbl.create 37 in
    let c_kw = Hashtbl.create 37 in
    List.iter
      (fun (i,t,flag) ->
         Hashtbl.add all_kw i t;
         if flag then Hashtbl.add c_kw i t
      )
      [
        "assert", ASSERT, false;
        "assigns", ASSIGNS, false;
        "assumes", ASSUMES, false;
        "axiom", AXIOM, false;
        "behavior", BEHAVIOR, false;
        "behaviors", BEHAVIORS, false;
        "char", CHAR, true;
        "complete", COMPLETE, false;
        "decreases", DECREASES, false;
        "disjoint", DISJOINT, false;
        "double", DOUBLE, true;
        "else", ELSE, true;
        "ensures", ENSURES, false ;
        "enum", ENUM, true;
        "float", FLOAT, true;
        "for", FOR, true;
        "if", IF, true;
        "int", INT, true;
        "integer", INTEGER, true;
        "invariant", INVARIANT, false;
        "global",    GLOBAL, false;
        "label", LABEL, false;
        "lemma", LEMMA, false;
        "logic", LOGIC, false;
        "long", LONG, true;
        "loop", LOOP, false;
        "pragma", PRAGMA, false;
        "predicate", PREDICATE, false;
        "reads", READS, false;
        "real", REAL, true;
        "requires", REQUIRES, false;
        "short", SHORT, true;
        "signed", SIGNED, true;
        "sizeof", SIZEOF, true;
        "slice", SLICE, false;
	"impact", IMPACT, false;
        "struct", STRUCT, true;
        "terminates", TERMINATES, false;
        "type", TYPE, false;
        "union", UNION, true;
        "unsigned", UNSIGNED, true;
        "variant", VARIANT, false;
        "void", VOID, true;
      ];
    fun s ->
      try
        Hashtbl.find (if Logic_const.is_kw_c_mode () then c_kw else all_kw) s
      with Not_found ->
        try
          if Hashtbl.find Logic_const.typenames s then
            TYPENAME s
          else IDENTIFIER s
        with Not_found -> IDENTIFIER s

  let bs_identifier =
    let h = Hashtbl.create 97 in
    List.iter (fun (i,t) -> Hashtbl.add h i t)
      [
        "\\at", AT;
        "\\base_addr", BASE_ADDR;
        "\\block_length", BLOCK_LENGTH;
        "\\empty", EMPTY;
        "\\exists", EXISTS;
        "\\false", FALSE;
        "\\forall", FORALL;
        "\\fresh", FRESH;
        "\\from", FROM;
        "\\inter", INTER;
        "\\lambda", LAMBDA;
        "\\max", IDENTIFIER "\\max";
        "\\min", IDENTIFIER "\\min";
        "\\nothing", NOTHING;
        "\\null", NULL;
        "\\numof", IDENTIFIER "\\numof";
        "\\old", OLD;
        "\\product", IDENTIFIER "\\product";
        "\\result", RESULT;
        "\\sum", IDENTIFIER "\\sum";
        "\\true", TRUE;
        "\\union", BSUNION;
        "\\valid", VALID;
        "\\valid_index", VALID_INDEX;
        "\\valid_range", VALID_RANGE;
      ];
    fun lexbuf ->
      let s = lexeme lexbuf in
      try Hashtbl.find h s
      with Not_found ->
        lex_error lexbuf ("illegal escape sequence " ^ s)


  let int_of_digit chr =
    match chr with
        '0'..'9' -> (Char.code chr) - (Char.code '0')
      | 'a'..'f' -> (Char.code chr) - (Char.code 'a') + 10
      | 'A'..'F' -> (Char.code chr) - (Char.code 'A') + 10
      | _ -> assert false

  (* Update lexer buffer. *)
  let update_newline_loc lexbuf =
    let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <-
      { pos with
	Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
	Lexing.pos_bol = pos.Lexing.pos_cnum;
      }

  (* Update lexer buffer. *)
  let update_line_loc lexbuf line absolute chars =
    let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <-
      { pos with
	Lexing.pos_lnum = if absolute then line else pos.Lexing.pos_lnum + line;
	Lexing.pos_bol = pos.Lexing.pos_cnum - chars;
      }

  (* Update lexer buffer. *)
  let update_file_loc lexbuf file =
    let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <-
      { pos with
	Lexing.pos_fname = file;
      }

  (* Update lexer buffer. *)
  let update_bol_loc lexbuf bol =
    let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <-
      { pos with
	Lexing.pos_bol = bol;
      }
}

let space = [' ' '\t' '\012' '\r']

let rD =	['0'-'9']
let rO = ['0'-'7']
let rL = ['a'-'z' 'A'-'Z' '_']
let rH = ['a'-'f' 'A'-'F' '0'-'9']
let rE = ['E''e']['+''-']? rD+
let rFS	= ('f'|'F'|'l'|'L')
let rIS = ('u'|'U'|'l'|'L')*
let comment_line = "//" [^'\n']*

let escape = '\\'
   ('\'' | '"' | '?' | '\\' | 'a' | 'b' | 'f' | 'n' | 'r'
   | 't' | 'v')

let hex_escape = '\\' ['x' 'X'] rH+
let oct_escape = '\\' rO rO? rO?

let utf8_char = ['\128'-'\254']+

rule token = parse
  | '@' | [' ' '\t' '\012' '\r']+ { token lexbuf }
  | '\n' { update_newline_loc lexbuf; token lexbuf }
  | comment_line '\n' { update_newline_loc lexbuf; token lexbuf }
  | comment_line eof { token lexbuf }

  | '\\' rL (rL | rD)* { bs_identifier lexbuf }
  | rL (rL | rD)*       { let s = lexeme lexbuf in identifier s }

  | '0'['x''X'] rH+ rIS?    { CONSTANT (IntConstant (lexeme lexbuf)) }
  | '0' rD+ rIS?            { CONSTANT (IntConstant (lexeme lexbuf)) }
  | rD+ rIS?                { CONSTANT (IntConstant (lexeme lexbuf)) }
  | ('L'? "'" as prelude) (([^'\'']|"\\'")+ as content) "'"
      {
        let b = Buffer.create 5 in
        Buffer.add_string b prelude;
        let lbf = Lexing.from_string content in
        chr b lbf
      }
  | rD+ rE rFS?             { CONSTANT (FloatConstant (lexeme lexbuf)) }
  | rD* "." rD+ (rE)? rFS?  { CONSTANT (FloatConstant (lexeme lexbuf)) }
  | rD+ "." rD* (rE)? rFS?  { CONSTANT (FloatConstant (lexeme lexbuf)) }

 (* hack to lex 0..3 as 0 .. 3 and not as 0. .3 *)
  | (rD+ as n) ".."         { lexbuf.lex_curr_pos <- lexbuf.lex_curr_pos - 2;
                              CONSTANT (IntConstant n) }

  | 'L'? '"' [^ '"']* '"'   { STRING_LITERAL (lexeme lexbuf) }

  | "==>"                   { IMPLIES }
  | "<==>"                  { IFF }
  | "&&"                    { AND }
  | "||"                    { OR }
  | "!"                     { NOT }
  | "$"                     { DOLLAR }
  | ","                     { COMMA }
  | "->"                    { ARROW }
  | "?"                     { Stack.push Test state_stack; QUESTION }
  | ";"                     { SEMICOLON }
  | ":"                     { match get_state() with
                                  Normal  -> COLON
                                | Test -> pop_state(); COLON2
                            }
  | "::"                    { COLONCOLON }
  | "."                     { DOT }
  | ".."                    { DOTDOT }
  | "..."                   { DOTDOTDOT }
  | "-"                     { MINUS }
  | "+"                     { PLUS }
  | "*"                     { STAR }
  | "&"                     { AMP }
  | "^^"                    { HATHAT }
  | "^"                     { HAT }
  | "|"                     { PIPE }
  | "~"                     { TILDE }
  | "/"                     { SLASH }
  | "%"                     { PERCENT }
  | "<"                     { LT }
  | ">"                     { GT }
  | "<="                    { LE }
  | ">="                    { GE }
  | "=="                    { EQ }
  | "="                     { EQUAL }
  | "!="                    { NE }
  | "("                     { Stack.push Normal state_stack; LPAR }
  | ")"                     { pop_state(); RPAR }
  | "{"                     { Stack.push Normal state_stack; LBRACE }
  | "}"                     { pop_state(); RBRACE }
  | "["                     { Stack.push Normal state_stack; LSQUARE }
  | "]"                     { pop_state(); RSQUARE }
  | "<:"                    { LTCOLON }
  | ":>"                    { COLONGT }
  | "<<"                    { LTLT }
  | ">>"                    { GTGT }
  | utf8_char as c          { find_utf8 c }
  | eof                     { EOF }
  | _   { lex_error lexbuf ("illegal character " ^ lexeme lexbuf) }

and chr buffer = parse
  | hex_escape
      { let s = lexeme lexbuf in
        let real_s = String.sub s 2 (String.length s - 2) in
        let rec add_one_char s =
          let l = String.length s in
          if l = 0 then ()
          else
          let h = int_of_digit s.[0] in
          let c,s =
            if l = 1 then (h,"")
            else
              (16*h + int_of_digit s.[1],
               String.sub s 2 (String.length s - 2))
          in
          Buffer.add_char buffer (Char.chr c); add_one_char s
        in add_one_char real_s; chr buffer lexbuf
      }
  | oct_escape
      { let s = lexeme lexbuf in
        let real_s = String.sub s 1 (String.length s - 1) in
        let rec value i s =
          if s = "" then i
          else value (8*i+int_of_digit s.[0])
            (String.sub s 1 (String.length s -1))
        in let c = value 0 real_s in
        Buffer.add_char buffer (Char.chr c); chr buffer lexbuf
      }
  | escape
      { Buffer.add_char buffer
          (match (lexeme lexbuf).[1] with
               'a' -> '\007'
             | 'b' -> '\b'
             | 'f' -> '\012'
             | 'n' -> '\n'
             | 'r' -> '\r'
             | 't' -> '\t'
             | '\'' -> '\''
             | '"' -> '"'
             | '?' -> '?'
             | '\\' -> '\\'
             | _ -> assert false
          ); chr buffer lexbuf}
  | eof { Buffer.add_char buffer '\'';
          CONSTANT (IntConstant (Buffer.contents buffer)) }
  | _  { Buffer.add_string buffer (lexeme lexbuf); chr buffer lexbuf }

{

  open Format

  let copy_lexbuf dest_lexbuf src_loc =
    update_file_loc dest_lexbuf src_loc.pos_fname;
    update_line_loc dest_lexbuf src_loc.pos_lnum true 0;
    let bol = src_loc.Lexing.pos_cnum - src_loc.Lexing.pos_bol in
    update_bol_loc dest_lexbuf (-bol)

  let start_pos lexbuf =
    let pos = lexeme_start_p lexbuf in
    pos.Lexing.pos_cnum - pos.Lexing.pos_bol

  let end_pos lexbuf =
    let pos = lexeme_end_p lexbuf in
    pos.Lexing.pos_cnum - pos.Lexing.pos_bol

  let parse_from_location f (loc, s : Lexing.position * string) =
    let lb = from_string s in
    copy_lexbuf lb loc;
    try
      f token lb
    with
      | Parsing.Parse_error as _e ->
          let start, stop = start_pos lb,end_pos lb in
          Cil.error_loc (
	    lb.lex_curr_p.Lexing.pos_fname,
	    lb.lex_curr_p.Lexing.pos_lnum,start,stop)
            "syntax error while parsing annotation@.";
          Logic_const.exit_kw_c_mode ();
          raise Parsing.Parse_error

      | Error ((b,e), m) ->
          Cil.error_loc (
	    lb.lex_curr_p.Lexing.pos_fname,
	    lb.lex_curr_p.Lexing.pos_lnum,b,e)
            "%s@."
            m;
          Logic_const.exit_kw_c_mode ();
          raise Parsing.Parse_error
      | Logic_const.Not_well_formed (loc, m) ->
          Cil.error_loc
            ((fst loc).Lexing.pos_fname,
             (fst loc).Lexing.pos_lnum,
             (fst loc).Lexing.pos_cnum - (fst loc).Lexing.pos_bol,
             (snd loc).Lexing.pos_cnum - (snd loc).Lexing.pos_bol)
            "%s@." m;
          Logic_const.exit_kw_c_mode ();
          raise Parsing.Parse_error


  let lexpr = parse_from_location Logic_parser.lexpr

  let annot = parse_from_location Logic_parser.annot

  let spec = parse_from_location Logic_parser.spec

}
