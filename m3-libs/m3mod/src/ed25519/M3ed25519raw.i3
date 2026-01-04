INTERFACE M3ed25519raw;

IMPORT Ctypes AS C;

<* EXTERNAL ed25519_create_seed *>
PROCEDURE CreateSeed(s: ADDRESS; );

<* EXTERNAL ed25519_create_keypair *>
PROCEDURE CreateKeypair(pub, prv, s: ADDRESS; ) ;

<* EXTERNAL ed25519_sign *>
PROCEDURE Sign(sig: ADDRESS; msg: ADDRESS; len: C.unsigned_int; pub, prv: ADDRESS; );

<* EXTERNAL ed25519_verify *>
PROCEDURE Verify(sig: ADDRESS; msg: ADDRESS; len: C.unsigned_int; pub: ADDRESS; ) : BOOLEAN;

<* EXTERNAL ed25519_add_scalar *>
PROCEDURE AddScalar(pub, prv, s : ADDRESS; );

<* EXTERNAL ed25519_key_exchange *>
PROCEDURE KeyExchange(shared, pub, prv : ADDRESS; );

END M3ed25519raw.
