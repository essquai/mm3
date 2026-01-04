(* Copyright 2026 Sunil Khare. All rights reserved            *)

(* A "Uint16.T" is a 16-bit integer
   This interface can be used to instantiate generic
   interfaces and modules such as "Table" and "List".         *)

INTERFACE Uint16;

IMPORT Word;

TYPE T = BITS 16 FOR [ 0 .. 16_FFFF ];

CONST Brand = "Uint16";

PROCEDURE Equal(a, b: T): BOOLEAN;
(* Return "a = b". *)

PROCEDURE Hash(a: T): Word.T;
(* Return "a". *)

PROCEDURE Compare(a, b: T): [-1..1];
(* Return "-1" if "a < b", "0" if "a = b", or "+1" if "a > b". *)

END Uint16.

