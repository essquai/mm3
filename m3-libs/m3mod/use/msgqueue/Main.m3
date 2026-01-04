MODULE Main;

IMPORT MsgQueue;
IMPORT Thread;
IMPORT Fmt, IO, Wr;

CONST
  QSIZE = 10;
  THREAD = 5;
  MSG = 20;

TYPE
  MqMsg = REF RECORD
    thr : CARDINAL;
    seq : CARDINAL;
  END;

VAR 
  TCode : CARDINAL;

(* Sender Thread *)
TYPE
  Sender = Thread.Closure OBJECT
	  t : CARDINAL;
	  q : MsgQueue.T;
	OVERRIDES
	  apply := EnqueueF;
  END;

PROCEDURE EnqueueF(self : Sender) : REFANY =
  VAR elem : MsgQueue.Msg; r : MqMsg;
  BEGIN
    FOR s := 1 TO MSG DO
	  r := NEW(MqMsg);
	  elem.TCode := TCode;
	  elem.Ref   := r;

	  r.thr := self.t;
	  r.seq := s;

	  self.q.append(elem);
	  IO.Put("--> thr/seq " & Fmt.Int(r.thr) & ":" & Fmt.Int(r.seq) & Wr.EOL);
	END;
	RETURN NIL;
  END EnqueueF;

(*
 * Test ()
 * Create a message queue of QSIZE
 * Spawn THREAD threads. each thread sends MSG msgs.
 * Receive THREAD * MSG messages, then exit
 * 
 *)
PROCEDURE Test() =
  VAR
    queue := MsgQueue.New(QSIZE);
	m : MsgQueue.Msg;
	r : MqMsg;
	thr : Sender;
  BEGIN

    FOR t := 1 TO THREAD DO
	  thr := NEW(Sender, t := 10+t, q := queue);
	  EVAL Thread.Fork(thr);
	END;

    (* Receive all the messages *)
	FOR t := 1 TO THREAD DO
	  FOR msgs := 1 TO MSG DO
	    queue.remove(m);
		r := NARROW(m.Ref, MqMsg);
		IO.Put("    <-- thr/seq " & Fmt.Int(r.thr) & ":" & Fmt.Int(r.seq) & Wr.EOL);
	  END;
	END;
  END Test;

BEGIN
  TCode := TYPECODE(MqMsg);
  Test();
END Main.
