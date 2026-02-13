INTERFACE M3CG_WASM;

(* WASM Code Generation *)

IMPORT M3CG;

TYPE T <: Public;
TYPE Public = M3CG.T OBJECT
  METHODS
    moduleWrite(binFileName, textFileName: TEXT);
  END;

PROCEDURE New(WasmDebugLevel : INTEGER; GenDebug: BOOLEAN) : T; 

END M3CG_WASM.
