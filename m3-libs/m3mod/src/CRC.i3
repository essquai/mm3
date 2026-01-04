(* Copyright 2026 Sunil Khare. All rights reserved *)

INTERFACE CRC;

IMPORT Byte, Uint16, Uint32;


TYPE MsgArr = REF ARRAY OF CHAR;


PROCEDURE Sum8( in : MsgArr; len : CARDINAL ) : Byte.T;
PROCEDURE Sum16( in : MsgArr; len : CARDINAL ) : Uint16.T;
PROCEDURE Sum32( in : MsgArr; len : CARDINAL ) : Uint32.T;
PROCEDURE CCITT1d0f( in : MsgArr; len : CARDINAL ) : Uint16.T;
PROCEDURE CCITTffff( in : MsgArr; len : CARDINAL ) : Uint16.T;
PROCEDURE Modbus( in : MsgArr; len : CARDINAL ) : Uint16.T;

END CRC.
