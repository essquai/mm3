(* Copyright 2026 Sunil Khare. All rights reserved.           *)

(* A "Byte.T" is an unsigned int that can be used to build    *) 
(* generic interfaces and modules such as "Table" and "List". *)

INTERFACE Byte;

IMPORT Word;

TYPE T = BITS 8 FOR [ 0 .. 16_FF ];

CONST Brand = "Byte";

PROCEDURE Equal(a, b: T): BOOLEAN;
(* Return "a = b". *)

PROCEDURE Hash(a: T): Word.T;
(* Return "a". *)

PROCEDURE Compare(a, b: T): [-1..1];
(* Return "-1" if "a < b", "0" if "a = b", or "+1" if "a > b". *)

END Byte.

