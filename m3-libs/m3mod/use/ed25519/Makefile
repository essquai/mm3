SRC = ../../src/ed25519
SOURCES = test.c $(SRC)/add_scalar.c $(SRC)/fe.c $(SRC)/ge.c               \
          $(SRC)/key_exchange.c $(SRC)/keypair.c $(SRC)/sc.c $(SRC)/seed.c \
          $(SRC)/sha512.c $(SRC)/sign.c $(SRC)/verify.c
CFLAGS  = -I $(SRC)

all:  test

test: $(SOURCES)
	$(CC) -o test $(CFLAGS) $(SOURCES)

