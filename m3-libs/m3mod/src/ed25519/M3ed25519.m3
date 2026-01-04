UNSAFE MODULE M3ed25519;

IMPORT M3ed25519raw;


PROCEDURE CreateSeed( VAR s: Seed ) =
  BEGIN
    M3ed25519raw.CreateSeed( ADR(s) );
  END CreateSeed;

PROCEDURE CreateKeypair( VAR pub: PubKey; VAR prv: PrivKey; VAR s: Seed; ) =
  BEGIN
    M3ed25519raw.CreateKeypair( ADR(pub), ADR(prv), ADR(s) );
  END CreateKeypair;

PROCEDURE Sign( VAR sig: Sig; msg: MsgArr; len: CARDINAL; VAR pub: PubKey; 
                VAR prv: PrivKey; ) =
  BEGIN
    M3ed25519raw.Sign( ADR(sig), Address(msg), len, ADR(pub), ADR(prv) );
  END Sign;

PROCEDURE Verify( VAR sig: Sig; msg: MsgArr; len: CARDINAL; 
                  VAR pub: PubKey; ) : BOOLEAN =
  BEGIN
    RETURN M3ed25519raw.Verify( ADR(sig), Address(msg), len, ADR(pub) );
  END Verify;

PROCEDURE AddScalar( VAR pub : PubKey; VAR prv : PrivKey; VAR s : Scalar; ) =
  BEGIN
    M3ed25519raw.AddScalar( ADR(pub), ADR(prv), ADR(s) );
  END AddScalar;

PROCEDURE AddScalarPublic( VAR pub : PubKey; VAR s : Scalar; ) =
  BEGIN
    M3ed25519raw.AddScalar( ADR(pub), NIL, ADR(s) );
  END AddScalarPublic;

PROCEDURE KeyExchange( VAR shared : ShareKey; VAR pub : PubKey;
                       VAR prv : PrivKey; ) =
  BEGIN
    M3ed25519raw.KeyExchange( ADR(shared), ADR(pub), ADR(prv) );
  END KeyExchange;

PROCEDURE Address( in : MsgArr ) : ADDRESS = 
  VAR addr : ADDRESS;
  BEGIN
      IF (TYPECODE(in) = TYPECODE(MsgArr)) THEN
          addr := ADR(in^[0]);
      ELSE
          addr := LOOPHOLE(in, ADDRESS);
      END;
      RETURN addr;
  END Address;

BEGIN
END M3ed25519.
