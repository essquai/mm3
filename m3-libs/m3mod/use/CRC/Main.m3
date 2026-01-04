MODULE Main;

IMPORT Byte, Uint16, Uint32, CRC;
IMPORT Fmt, IO, Text, Wr;


TYPE chk_tp = RECORD
	input       : TEXT;             (* The input string to be checked            *)
	(*crc8        : Byte.T;*)        (* The  8 bit wide CRC8 of the input string	 *)
	crc16       : Uint16.T;       (* The 16 bit wide CRC16 of the input string *)
	crc32       : Uint32.T;       (* The 32 bit wide CRC32 of the input string *)
	crcdnp      : Uint16.T;       (* The 16 bit wide DNP CRC of the string	 *)
	crcmodbus   : Uint16.T;		(* The 16 bit wide Modbus CRC of the string  *)
	crcsick     : Uint16.T;		(* The 16 bit wide Sick CRC of the string    *)
	crcxmodem   : Uint16.T;		(* The 16 bit wide XModem CRC of the string  *)
	crc1d0f     : Uint16.T;		(* The 16 bit wide CCITT CRC with 1D0F start *)
	crcffff     : Uint16.T;		(* The 16 bit wide CCITT CRC with FFFF start *)
	crckermit   : Uint16.T;		(* The 16 bit wide CRC Kermit of the string  *)
	crc8        : Byte.T;        (* The  8 bit wide CRC8 of the input string	 *)
END;

CONST checks = ARRAY OF chk_tp {
	chk_tp { "123456789",   16_BB3D, 16_CBF43926, 16_82EA, 16_4B37, 16_56A6, 16_31C3, 16_E5CC, 16_29B1, 16_8921, 16_A2 },
	chk_tp { "Lammert Bies", 16_B638, 16_43C04CA6, 16_4583, 16_B45C, 16_1108, 16_CEC8, 16_67A2, 16_4A31, 16_F80D, 16_A5 },
	chk_tp { "",           16_0000, 16_00000000, 16_FFFF, 16_FFFF, 16_0000, 16_0000, 16_1D0F, 16_FFFF, 16_0000, 16_00 },
	chk_tp { " ",          16_D801, 16_E96CCF45, 16_50D6, 16_98BE, 16_2000, 16_2462, 16_E8FE, 16_C592, 16_0221, 16_86 }
};


(*
 * int test_crc( bool verbose );
 *
 * The function test_crc_32() tests the functionality of the implementation of
 * the CRC library functions on a specific platform.
 *)
PROCEDURE test_crc ( ) : INTEGER =
  VAR
	errors    : INTEGER := 0;
	len       : INTEGER;
    ptr       := NEW(CRC.MsgArr, 32);
	crc8      : Byte.T;
	crc16     : Uint16.T;
	crcmodbus : Uint16.T;
	crc1d0f   : Uint16.T;
	crcffff   : Uint16.T;
	crc32     : Uint32.T;

  BEGIN
	IO.Put( "Testing CRC routines: " );

	FOR a := FIRST(checks) TO LAST(checks) DO
		len := Text.Length( checks[a].input );
        FOR i := 0 TO len-1 DO
		    ptr[i] := Text.GetChar(checks[a].input, i);
		END;

		crc8      := CRC.Sum8     ( ptr, len );
		crc16     := CRC.Sum16    ( ptr, len );
		crc32     := CRC.Sum32    ( ptr, len );
		crcmodbus := CRC.Modbus   ( ptr, len );
		crc1d0f   := CRC.CCITT1d0f( ptr, len );
		crcffff   := CRC.CCITTffff( ptr, len );

		IF ( crc8 # checks[a].crc8 ) THEN
			IO.Put("    FAIL: Sum8 \"" & checks[a].input & "\" return ");
			IO.Put(Fmt.Unsigned(crc8) & " not " & Fmt.Unsigned(checks[a].crc8));
			IO.Put(Wr.EOL);
			INC(errors);
		END;

		IF ( crc16 # checks[a].crc16 ) THEN
			IO.Put("    FAIL: Sum16 \"" & checks[a].input & "\" return ");
			IO.Put(Fmt.Unsigned(crc16) & " not " & Fmt.Unsigned(checks[a].crc16));
			IO.Put(Wr.EOL);
			INC(errors);
		END;

		IF ( crc32 # checks[a].crc32 ) THEN
			IO.Put("    FAIL: Sum32 \"" & checks[a].input & "\" return ");
			IO.Put(Fmt.Unsigned(crc32) & " not " & Fmt.Unsigned(checks[a].crc32));
			IO.Put(Wr.EOL);
			INC(errors);
		END;

		IF ( crcmodbus # checks[a].crcmodbus ) THEN
			IO.Put("    FAIL: Modbus \"" & checks[a].input & "\" return ");
			IO.Put(Fmt.Unsigned(crcmodbus) & " not " & Fmt.Unsigned(checks[a].crcmodbus));
			IO.Put(Wr.EOL);
			INC(errors);
		END;

		IF ( crc1d0f # checks[a].crc1d0f ) THEN
			IO.Put("    FAIL: CRC CCITT 1d0f \"" & checks[a].input & "\" return ");
			IO.Put(Fmt.Unsigned(crc1d0f) & " not " & Fmt.Unsigned(checks[a].crc1d0f));
			IO.Put(Wr.EOL);
			INC(errors);
		END;

		IF ( crcffff # checks[a].crcffff ) THEN
			IO.Put("    FAIL: CRC CCITT ffff \"" & checks[a].input & "\" return ");
			IO.Put(Fmt.Unsigned(crcffff) & " not " & Fmt.Unsigned(checks[a].crcffff));
			IO.Put(Wr.EOL);
			INC(errors);
		END;
    END;

	IF ( errors = 0 ) THEN IO.Put("OK" & Wr.EOL );
	ELSE                   IO.Put("FAILED " & Fmt.Int(errors) & " checks" );
                        IO.Put(Wr.EOL);
	END;

	RETURN errors;
  END test_crc;

(*
 * Test ()
 *
 * Testall is a commandline utility that tests the functionality of the libcrc
 * routines on a the current platform. The result is printed to stdout. The
 * program returns an integer value which can be catched by a shell script. The
 * value is equal to the number of errors encountered.
 *)
PROCEDURE Test() =
  VAR problems := 0;
  BEGIN

	problems := test_crc ();

	IF ( problems = 0 ) THEN IO.Put("**** All tests succeeded" &Wr.EOL );
	ELSE                 IO.Put ("**** A TOTAL OF " & Fmt.Int(problems) );
	                     IO.Put(" TESTS FAILED, PLEASE CORRECT THE DETECTED PROBLEMS ****" & Wr.EOL );
    END;						 

  END Test;

BEGIN
  Test();
END Main.
