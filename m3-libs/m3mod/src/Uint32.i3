(* Copyright 2026 Sunil Khare. All rights reserved            *)

(* A "Uint32.T" is a 32-bit integer whether compiled on 32-bit or
   64-bit machines.  This interface can be used to instantiate
   generic interfaces and modules such as "Table" and "List". *)

INTERFACE Uint32;

IMPORT Word;

TYPE T = BITS 32 FOR [ 0 .. 16_FFFFFFFF ];

CONST Brand = "Uint32";

PROCEDURE Equal(a, b: T): BOOLEAN;
(* Return "a = b". *)

PROCEDURE Hash(a: T): Word.T;
(* Return "a". *)

PROCEDURE Compare(a, b: T): [-1..1];
(* Return "-1" if "a < b", "0" if "a = b", or "+1" if "a > b". *)

END Uint32.

