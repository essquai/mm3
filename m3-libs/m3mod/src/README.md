# m3mod - Modded Modula-3 system package

This package contains modules useful for systems programming.

## Types

The types {Byte, Uint16, Int16, Uint32} are provided for use in generics
supplementary to Integer in the m3core package. Sequences are also
instantiated for each with the libm3 generic module.

```M3

IMPORT ByteSeq;

PROCEDURE p () = 
  VAR
    bseq := NEW(ByteSeq.T).init(8);
  BEGIN
    bseq.addhi(32);
    ...


```


## Cyclic Redundancy Checks

The CRC Module is derived from [libcrc](https://github.com/lammertb/libcrc), 
a multi platform CRC library in C by Lammert Bies.

### Usage

Various types and widths of CRCs can be calculated for CHAR arrays,
interface as follows.

```M3
INTERFACE CRC;

IMPORT Byte, Uint16, Uint32;


TYPE MsgArr = REF ARRAY OF CHAR;


PROCEDURE Sum8( in : MsgArr; len : CARDINAL ) : Byte.T;
PROCEDURE Sum16( in : MsgArr; len : CARDINAL ) : Uint16.T;
PROCEDURE Sum32( in : MsgArr; len : CARDINAL ) : Uint32.T;
PROCEDURE CCITT1d0f( in : MsgArr; len : CARDINAL ) : Uint16.T;
PROCEDURE CCITTffff( in : MsgArr; len : CARDINAL ) : Uint16.T;
PROCEDURE Modbus( in : MsgArr; len : CARDINAL ) : Uint16.T;

END CRC.
```


## Message Queue

The Message Queue Module is an implementation of the bounded
buffer monitor defined in the 
[monitor paper](https://dl.acm.org/doi/epdf/10.1145/355620.361161) 
by C.A.R. Hoare. It enables threads to append messages to - and remove
them from - a shared queue, safely. A message is defined here as
a TYPECODE and REF.

### Usage

Given a MsgQueue.T, producers may append to and consumers may remove
from the queue. The New parameter specifies the size of the queue;
append and remove block when the queue is full or empty, respectively.

```M3
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
```


## Ed25519

See sub-directory

