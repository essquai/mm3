INTERFACE MsgQueue;

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
    size() : CARDINAL;
  END;


PROCEDURE New(n : CARDINAL := 3) : T;

END MsgQueue.
