INTERFACE M3CG_WASM;

(* WASM Code Generation *)

IMPORT M3CG;

TYPE T <: Public;
TYPE Public = M3CG.T OBJECT
  METHODS
    module_write(binFileName, textFileName: TEXT) : INTEGER;
  END;

PROCEDURE New(WasmDebug : BOOLEAN; GenDebug: BOOLEAN) : T; 

END M3CG_WASM.
