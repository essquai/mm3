INTERFACE Pool;

(* Pool
 * A set of IDs in the range 1..N that can be borrowed and
 * returned. Borrowed IDs are not loaned out again until 
 * they've been returned. Procedures are thread-safe.
 *)

IMPORT IntPQ;

TYPE T = REF RECORD
    m     : MUTEX;
    N     : CARDINAL;
    left  : INTEGER;
    elt   : REF ARRAY OF IntPQ.Elt;
    alloc : IntPQ.T;
    avail : IntPQ.T;
END;

PROCEDURE New    (N: CARDINAL) : T;
PROCEDURE Borrow (t : T) : INTEGER;
PROCEDURE Return (t : T; p : INTEGER );
PROCEDURE Avail  (t : T) : CARDINAL;

END Pool.
