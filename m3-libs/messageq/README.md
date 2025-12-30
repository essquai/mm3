# MessageQ - Modula-3

The MessageQ Module is an implementation of the bounded buffer monitor
defined in the 
[monitor paper](https://dl.acm.org/doi/epdf/10.1145/355620.361161) 
by C.A.R. Hoare. It enables threads to append messages to - and remove
them from - a shared queue, safely.

## Usage

This repo includes a program illustrating the use of this module,
with interface as follows.

```M3
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
```