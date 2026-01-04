INTERFACE M3ed25519;

TYPE 
  Byte      = BITS 8 FOR [ 0 .. 16_FF ]; (* TODO: m3mod/Byte *)
  Bytes32   = ARRAY [0..31] OF Byte;
  Bytes64   = ARRAY [0..63] OF Byte;
 
  Seed      = Bytes32;
  Sig       = Bytes64;
  PubKey    = Bytes32;
  PrivKey   = Bytes64;
  ShareKey  = Bytes32;
  Scalar    = Bytes32;

  MsgArr    = REF ARRAY OF CHAR;


PROCEDURE CreateSeed( VAR s: Seed );

PROCEDURE CreateKeypair( VAR pub: PubKey; VAR prv: PrivKey; VAR s: Seed; );

PROCEDURE Sign( VAR sig: Sig; msg: MsgArr; len: CARDINAL; VAR pub: PubKey; 
                VAR prv: PrivKey; );

PROCEDURE Verify( VAR sig: Sig; msg: MsgArr; len: CARDINAL; 
                  VAR pub: PubKey; ) : BOOLEAN;

PROCEDURE AddScalar( VAR pub : PubKey; VAR prv : PrivKey; VAR s : Scalar; );

PROCEDURE AddScalarPublic( VAR pub : PubKey; VAR s : Scalar; );

PROCEDURE KeyExchange( VAR shared : ShareKey; VAR pub : PubKey;
                       VAR prv : PrivKey; );

END M3ed25519.
