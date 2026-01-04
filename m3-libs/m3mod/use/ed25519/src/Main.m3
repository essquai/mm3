UNSAFE MODULE Main;

IMPORT Fmt, IO, Tick, Text, Word, Wr;
IMPORT M3ed25519 AS ED;

PROCEDURE DoIt () = 
  VAR
    seed : ED.Seed;
    signature : ED.Sig;
    public_key, other_public_key : ED.PubKey;
    private_key, other_private_key : ED.PrivKey;
    shared_secret, other_shared_secret : ED.ShareKey;
    scalar : ED.Scalar;
    start, finish : Tick.T;
    elapsed : LONGREAL;
    msg : TEXT := "Hello, world";
    msg_ref := NEW(REF ARRAY OF CHAR, 32);
    message_len := Text.Length(msg);
    keyEx := TRUE;
  
  BEGIN
    (* Set up the msg reference *)
    FOR i := 0 TO message_len-1 DO
      msg_ref^[i] := Text.GetChar(msg, i);
    END;
    (* Create seed and keypair sign message *)
    ED.CreateSeed(seed);
    ED.CreateKeypair(public_key, private_key, seed);
    ED.Sign(signature, msg_ref, message_len, public_key, private_key);

    (* Validate the signature *)
    IF (ED.Verify(signature, msg_ref, message_len, public_key)) THEN
      IO.Put("valid signature" & Wr.EOL);
    ELSE
      IO.Put("invalid signature");
    END;


    (* Create scalar and add to keypair *)
    ED.CreateSeed(scalar);
    ED.AddScalar(public_key, private_key, scalar);

    (* Sign and verify *)
    ED.Sign(signature, msg_ref, message_len, public_key, private_key);
    IF (ED.Verify(signature, msg_ref, message_len, public_key)) THEN
      IO.Put("valid signature" & Wr.EOL);
    ELSE
      IO.Put("invalid signature");
    END;

    (* Forge and verify *)
    signature[44] := Word.Xor(signature[44], 16_10);
    IF (ED.Verify(signature, msg_ref, message_len, public_key)) THEN
      IO.Put("did not detect signature change" & Wr.EOL);
    ELSE
      IO.Put("correctly detected signature change" & Wr.EOL);
    END;

    (* generate two keypairs for testing key exchange *)
    ED.CreateSeed(seed);
    ED.CreateKeypair(public_key, private_key, seed);
    ED.CreateSeed(seed);
    ED.CreateKeypair(other_public_key, other_private_key, seed);

    (* create two shared secrets - from both perspectives - and check if they're equal *)
    ED.KeyExchange(shared_secret, other_public_key, private_key);
    ED.KeyExchange(other_shared_secret, public_key, other_private_key);

    (* create two shared secrets - from both perspectives - and check if they're equal *)
    FOR i := FIRST(shared_secret) TO LAST(shared_secret) DO
      IF (shared_secret[i] # other_shared_secret[i]) THEN
        IO.Put("key exchange incorrect index " & Fmt.Int(i) & Wr.EOL);
        keyEx := FALSE;
      END;
    END;
    IF (keyEx) THEN
      IO.Put("key exchange was correct" & Wr.EOL);
    END;


    (**** PERFORMANCE ****)
    IO.Put("testing seed generation performance: ");
    start := Tick.Now ();
    FOR i := 0 TO 10000 DO
        ED.CreateSeed(seed);
    END;
    finish := Tick.Now ();
    elapsed := Tick.ToSeconds(finish - start) / FLOAT(10000, LONGREAL);
    IO.Put(Fmt.LongReal(elapsed, prec := 10) &" s per seed" & Wr.EOL);


    IO.Put("testing key generation performance: ");
    start := Tick.Now ();
    FOR i := 0 TO 10000 DO
      ED.CreateKeypair(public_key, private_key, seed);
    END;
    finish := Tick.Now ();
    elapsed := Tick.ToSeconds(finish - start) / FLOAT(10000, LONGREAL);
    IO.Put(Fmt.LongReal(elapsed, prec := 10) &" s per keypair" & Wr.EOL);


    IO.Put("testing sign performance: ");
    start := Tick.Now ();
    FOR i := 0 TO 10000 DO
      ED.Sign(signature, msg_ref, message_len, public_key, private_key);
    END;
    finish := Tick.Now ();
    elapsed := Tick.ToSeconds(finish - start) / FLOAT(10000, LONGREAL);
    IO.Put(Fmt.LongReal(elapsed, prec := 10) &" s per signature" & Wr.EOL);


    IO.Put("testing verify performance: ");
    start := Tick.Now ();
    FOR i := 0 TO 10000 DO
      EVAL ED.Verify(signature, msg_ref, message_len, public_key);
    END;
    finish := Tick.Now ();
    elapsed := Tick.ToSeconds(finish - start) / FLOAT(10000, LONGREAL);
    IO.Put(Fmt.LongReal(elapsed, prec := 10) &" s per signature" & Wr.EOL);


    IO.Put("testing keypair scalar addition performance: ");
    start := Tick.Now ();
    FOR i := 0 TO 10000 DO
      ED.AddScalar(public_key, private_key, scalar);
    END;
    finish := Tick.Now ();
    elapsed := Tick.ToSeconds(finish - start) / FLOAT(10000, LONGREAL);
    IO.Put(Fmt.LongReal(elapsed, prec := 10) &" s per keypair" & Wr.EOL);


    IO.Put("testing public key scalar addition performance: ");
    start := Tick.Now ();
    FOR i := 0 TO 10000 DO
      ED.AddScalarPublic(public_key, scalar);
    END;
    finish := Tick.Now ();
    elapsed := Tick.ToSeconds(finish - start) / FLOAT(10000, LONGREAL);
    IO.Put(Fmt.LongReal(elapsed, prec := 10) &" s per key" & Wr.EOL);


    IO.Put("testing key exchange performance: ");
    start := Tick.Now ();
    FOR i := 0 TO 10000 DO
      ED.KeyExchange(shared_secret, other_public_key, private_key);
    END;
    finish := Tick.Now ();
    elapsed := Tick.ToSeconds(finish - start) / FLOAT(10000, LONGREAL);
    IO.Put(Fmt.LongReal(elapsed, prec := 10) &" s per shared secret" & Wr.EOL);


  END DoIt;


BEGIN
  DoIt();
END Main.