INTERFACE MessageQ;

TYPE 

  Msg  = RECORD
    TCode : CARDINAL;
    Ref   : REFANY;
  END;

  T <: Public;
  Public = MUTEX OBJECT
  METHODS
    append(m : Msg);
    remove(VAR m : Msg);
  END;


PROCEDURE New(n : CARDINAL) : T;

END MessageQ.