(* Copyright 2026 Sunil Khare. All rights reserved *)

MODULE CRC;

IMPORT Byte, Uint16, Uint32;
IMPORT Word;

CONST
  CRC_START_8		        : Byte.T =  16_00;
	CRC_START_16	        : Uint16.T = 16_0000;
	CRC_START_MODBUS	    : Uint16.T = 16_FFFF;
	CRC_START_CCITT_1D0F	: Uint16.T = 16_1D0F;
	CRC_START_CCITT_FFFF	: Uint16.T = 16_FFFF;
	CRC_START_32		      : Uint32.T = 16_FFFFFFFF;

	CRC_POLY_16		        : Uint16.T = 16_A001;
	CRC_POLY_32		        : Uint32.T = 16_EDB88320;
	CRC_POLY_CCITT        : Uint16.T = 16_1021;


CONST
  sht75_crc_table = ARRAY OF Byte.T {
	0,   49,  98,  83,  196, 245, 166, 151, 185, 136, 219, 234, 125, 76,  31,  46,
	67,  114, 33,  16,  135, 182, 229, 212, 250, 203, 152, 169, 62,  15,  92,  109,
	134, 183, 228, 213, 66,  115, 32,  17,  63,  14,  93,  108, 251, 202, 153, 168,
	197, 244, 167, 150, 1,   48,  99,  82,  124, 77,  30,  47,  184, 137, 218, 235,
	61,  12,  95,  110, 249, 200, 155, 170, 132, 181, 230, 215, 64,  113, 34,  19,
	126, 79,  28,  45,  186, 139, 216, 233, 199, 246, 165, 148, 3,   50,  97,  80,
	187, 138, 217, 232, 127, 78,  29,  44,  2,   51,  96,  81,  198, 247, 164, 149,
	248, 201, 154, 171, 60,  13,  94,  111, 65,  112, 35,  18,  133, 180, 231, 214,
	122, 75,  24,  41,  190, 143, 220, 237, 195, 242, 161, 144, 7,   54,  101, 84,
	57,  8,   91,  106, 253, 204, 159, 174, 128, 177, 226, 211, 68,  117, 38,  23,
	252, 205, 158, 175, 56,  9,   90,  107, 69,  116, 39,  22,  129, 176, 227, 210,
	191, 142, 221, 236, 123, 74,  25,  40,  6,   55,  100, 85,  194, 243, 160, 145,
	71,  118, 37,  20,  131, 178, 225, 208, 254, 207, 156, 173, 58,  11,  88,  105,
	4,   53,  102, 87,  192, 241, 162, 147, 189, 140, 223, 238, 121, 72,  27,  42,
	193, 240, 163, 146, 5,   52,  103, 86,  120, 73,  26,  43,  188, 141, 222, 239,
	130, 179, 224, 209, 70,  119, 36,  21,  59,  10,  89,  104, 255, 206, 157, 172
};

VAR
  crc_tab16    : ARRAY [0..255] OF Uint16.T;
  crc_tabCCITT : ARRAY [0..255] OF Uint16.T;
  crc_tab32    : ARRAY [0..255] OF Uint32.T;


(* -------------------------------------------------------------- 8-bit *)
PROCEDURE Sum8( ptr : MsgArr; len : CARDINAL ) : Byte.T =
  VAR
    idx : INTEGER;
	  crc : Byte.T := CRC_START_8;
  BEGIN
      FOR a := 0 TO len-1 DO
          idx := ORD(ptr[a]);
          idx := Word.Xor(idx, crc);
          idx := Word.And(idx, 16_FF);
          crc := sht75_crc_table[idx];
      END;
	    RETURN crc;
  END Sum8;

(* ------------------------------------------------------------- 16-bit *)
PROCEDURE Sum16( ptr : MsgArr; len : CARDINAL ) : Uint16.T =
  BEGIN
      RETURN generic16( ptr, len, CRC_START_16 );
  END Sum16;

PROCEDURE Modbus( ptr : MsgArr; len : CARDINAL ) : Uint16.T =
  BEGIN
      RETURN generic16( ptr, len, CRC_START_MODBUS );
  END Modbus;

PROCEDURE generic16( ptr : MsgArr; len : CARDINAL; start : Uint16.T ) : Uint16.T =
  VAR
    crc     : Uint16.T := start;
    idx     : Uint16.T;
    low     : Uint16.T;
	  short_c : Uint16.T;

  BEGIN
      FOR a := 0 TO len-1 DO
          short_c := Word.And(ORD(ptr[a]), 16_FF);
          idx     := Word.Xor(crc, short_c);
          idx     := Word.And(idx, 16_ff);
          low     := Word.Shift(crc, -8);

          crc     := Word.Xor(low, crc_tab16[idx])
      END;
      RETURN crc;
  END generic16;

(* ------------------------------------------------------------- 32-bit *)
PROCEDURE Sum32( ptr : MsgArr; len : CARDINAL) : Uint32.T =
  VAR
    crc    : Uint32.T := CRC_START_32;
    long_c : Uint32.T;
    idx    : Uint32.T;
  BEGIN
    FOR a := 0 TO len-1 DO
        long_c := Word.And(ORD(ptr[a]), 16_000000FF);
        idx    := Word.Xor(crc, long_c);
        idx    := Word.And(idx, 16_FF);

        crc    := Word.Xor(Word.Shift(crc, -8) , crc_tab32[idx]);
	  END;
    crc := Word.Xor(crc, 16_FFFFFFFF);
	  RETURN crc;

  END Sum32;

(* -------------------------------------------------------------- CCITT *)
PROCEDURE CCITT1d0f( ptr : MsgArr; len : CARDINAL; ) : Uint16.T =
  BEGIN
      RETURN genericCCITT( ptr, len, CRC_START_CCITT_1D0F)
  END CCITT1d0f;

PROCEDURE CCITTffff( ptr : MsgArr; len : CARDINAL; ) : Uint16.T =
  BEGIN
      RETURN genericCCITT( ptr, len, CRC_START_CCITT_FFFF)
  END CCITTffff;

PROCEDURE genericCCITT( ptr : MsgArr; len : CARDINAL; start : Uint16.T ) : Uint16.T =
  VAR
    crc     : Uint16.T := start;
    idx     : Uint16.T;
    shift   : Uint16.T;
	  short_c : Uint16.T;
  BEGIN
      FOR a := 0 TO len-1 DO
          short_c := Word.And(ORD(ptr[a]), 16_FF);
          shift   := Word.Shift(crc, -8);   
          idx     := Word.Xor(shift, short_c);             (* crc>>8 XOR short_c  *)         

          shift   := Word.And(Word.Shift(crc, 8), 16_FFFF);           
          crc     := Word.Xor(shift, crc_tabCCITT[idx]);   (* crc<<8 XOR tab[idx] *)
      END;
      RETURN crc;
  END genericCCITT;

(* --------------------------------------------------- Table Generation *)
PROCEDURE init_crc16_tab( ) =
  VAR
	  crc : Uint16.T;
	  c   : Uint16.T;
    x   : Uint16.T;
  BEGIN
	  FOR i := 0 TO 255 DO
		  crc := 0;
		  c   := i;

		  FOR j := 0 TO 7 DO
        x := Word.Xor(crc, c);
        x := Word.And(x, 16_0001);
			  IF ( x = 1 ) THEN
          crc := Word.Xor(Word.Shift(crc, -1), CRC_POLY_16);
			  ELSE
          crc := Word.Shift(crc, -1);
        END;
			  c := Word.Shift(c, -1);
		  END;

		  crc_tab16[i] := crc;
	  END;
  END init_crc16_tab;


PROCEDURE init_crcCCITT_tab( ) =
  VAR
	  crc : Uint16.T;
	  c   : Uint16.T;
    x   : Uint16.T;
  BEGIN
	  FOR i := 0 TO 255 DO
		  crc := 0;
		  c   := Word.Shift(i, 8);

		  FOR j := 0 TO 7 DO
        x := Word.Xor(crc, c);
        x := Word.And(x, 16_8000);
			  IF ( x = 16_8000 ) THEN
          x   := Word.And(Word.Shift(crc, 1), 16_FFFF);
          crc := Word.Xor(x, CRC_POLY_CCITT);
			  ELSE
          crc := Word.And(Word.Shift(crc, 1), 16_FFFF);
        END;
			  c := Word.And(Word.Shift(c, 1), 16_FFFF);
		  END;

		  crc_tabCCITT[i] := crc;
	  END;
  END init_crcCCITT_tab;

PROCEDURE init_crc32_tab( ) =
  VAR crc : Uint32.T; x : Uint32.T;
  BEGIN
	    FOR i := 0 TO 255 DO
		    crc := i;
        FOR j := 0 TO 7 DO
          x := Word.And(crc, 16_00000001);
          IF ( x = 1 ) THEN
              crc := Word.Xor(Word.Shift(crc, -1), CRC_POLY_32);
          ELSE
              crc := Word.Shift(crc, -1);
          END;
        END;
		    crc_tab32[i] := crc;
      END;
  END init_crc32_tab;


BEGIN
  init_crc16_tab();
  init_crcCCITT_tab();
  init_crc32_tab();
END CRC.

