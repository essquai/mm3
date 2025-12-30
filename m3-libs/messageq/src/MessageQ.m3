MODULE MessageQ;

IMPORT Thread;

REVEAL 
  T = Public BRANDED "Bounded-Buffer" OBJECT
    N        : CARDINAL;
    last     : CARDINAL;
    count    : CARDINAL;

    buffer   : REF ARRAY OF Msg;
    nonempty : Thread.Condition;
    nonfull  : Thread.Condition;
  OVERRIDES
    append := Append;
    remove := Remove;
  END;


PROCEDURE New(n : CARDINAL) : T =
  VAR q : T;
  BEGIN
    q          := NEW(T);
    q.N        := n;
    q.last     := 0;
    q.count    := 0;
    q.buffer   := NEW(REF ARRAY OF Msg, n);
    q.nonempty := NEW(Thread.Condition);
    q.nonfull  := NEW(Thread.Condition);

    RETURN q;
  END New;

PROCEDURE Append(q : T; m : Msg) =
  BEGIN
    LOCK q DO
      (* Conditions in Modula-3 are not the same as Hoare's *)
      WHILE q.count = q.N DO Thread.Wait(q, q.nonfull) END;

      q.buffer[q.last] := m;
      q.last  := (q.last + 1) MOD q.N;
      INC(q.count);
    END;
    Thread.Signal(q.nonempty);
  END Append;

PROCEDURE Remove(q : T; VAR m : Msg) =
  BEGIN
    LOCK q DO
      (* Conditions in Modula-3 are not the same as Hoare's *)
      WHILE q.count = 0 DO Thread.Wait(q, q.nonempty) END;

      (* Pleasingly, MOD with -ve numbers ranges over the size *)
      m := q.buffer[(q.last - q.count) MOD q.N];
      DEC(q.count);
    END;
    Thread.Signal(q.nonfull);
  END Remove;

BEGIN
END MessageQ.