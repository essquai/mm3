MODULE Pool;

IMPORT IntPQ;

(* allocate s elements *)
PROCEDURE New(N: CARDINAL) : T =
  VAR t := NEW(T);
  BEGIN
    t.m     := NEW(MUTEX);
    t.N     := N;
    t.left  := N;
    t.elt   := NEW(REF ARRAY OF IntPQ.Elt, N+1);
    t.alloc := NEW(IntPQ.Default).init(N);
    t.avail := NEW(IntPQ.Default).init(N);
    FOR i := 1 TO N DO
        t.elt[i]          := NEW(IntPQ.Elt);
        t.elt[i].priority := i;
        t.avail.insert(t.elt[i]);
    END;
    RETURN t;
  END New;

(* move from avail to alloc *)
PROCEDURE Borrow(t : T) : INTEGER =
  VAR id := 0; elt : IntPQ.Elt;
  BEGIN
      LOCK t.m DO
        TRY
          elt := t.avail.deleteMin();
          id  := elt.priority;
          t.alloc.insert(elt);
        EXCEPT
        | IntPQ.Empty => 
            <* ASSERT FALSE *>
        END;
        t.left := t.left - 1;
      END;
      RETURN(id)
  END Borrow;

(* move from alloc to avail *)
PROCEDURE Return(t : T; id : INTEGER; ) = 
  VAR elt : IntPQ.Elt;
  BEGIN
      <* ASSERT id >= 1 AND id <= t.N *>
      elt := t.elt[id];
      LOCK t.m DO
        TRY
          t.alloc.delete(elt);
          t.avail.insert(elt);
        EXCEPT
        | IntPQ.NotInQueue => 
            <* ASSERT FALSE *>
        END;
        t.left := t.left + 1;
      END;
  END Return;

(* ids left in the pool *)
PROCEDURE Avail(t : T; ) : CARDINAL =
  VAR num : CARDINAL;
  BEGIN
      LOCK t.m DO
        num := t.left;
      END;
      RETURN num;
  END Avail;

BEGIN
END Pool.
