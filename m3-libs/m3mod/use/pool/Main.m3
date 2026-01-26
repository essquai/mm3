MODULE Main;

IMPORT IO, Fmt, Wr;
IMPORT Pool;


PROCEDURE TestP() = 
  VAR
    pool := Pool.New(10);
    n    : ARRAY [1..10] OF INTEGER;
    x    : INTEGER := 1;
  BEGIN
    IO.Put("*** P ***" & Wr.EOL);
    FOR i := 1 TO 4 DO
       n[i] := Pool.Borrow(pool);
       IO.Put("Borrow=" & Fmt.Int(n[i]) & " avail = " & Fmt.Int(Pool.Avail(pool)));
       IO.Put(Wr.EOL);
    END;
    FOR i := 2 TO 4 DO
       Pool.Return(pool, n[i]);
       IO.Put("Return=" & Fmt.Int(n[i]) & " avail = " & Fmt.Int(Pool.Avail(pool)));
       IO.Put(Wr.EOL);
    END;
    FOR i := 5 TO 8 DO
       n[i] := Pool.Borrow(pool);
       IO.Put("Borrow=" & Fmt.Int(n[i]) & " avail = " & Fmt.Int(Pool.Avail(pool)));
       IO.Put(Wr.EOL);
    END;
    FOR i := 5 TO 8 DO
       Pool.Return(pool, n[i]);
       IO.Put("Return=" & Fmt.Int(n[i]) & " avail = " & Fmt.Int(Pool.Avail(pool)));
       IO.Put(Wr.EOL);
    END;
    WHILE Pool.Avail(pool) > 0 DO
       x := Pool.Borrow(pool);
       IO.Put("Exhaust=" & Fmt.Int(x) & " avail = " & Fmt.Int(Pool.Avail(pool)));
       IO.Put(Wr.EOL);
    END;
    IO.Put("=========" & Wr.EOL);
  END TestP;


PROCEDURE main() = 
  BEGIN
    TestP();
  END main;

BEGIN
  main();
END Main.
