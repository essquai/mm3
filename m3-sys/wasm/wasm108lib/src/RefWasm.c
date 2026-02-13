#include <binaryen-c.h>

#include <stdio.h>

void refDump(char *v, long len) {
  int i;
  char c;
  for (i = 0; i < len; i++) {
    c = v[i] & 0xFF;
    printf(" %x", c);
  }
  printf("\n");
}

void *RefConst(void *moduleRef, struct BinaryenLiteral *value) {
    void *r;
    printf("RefConst ");
    refDump((char *) value, sizeof(struct BinaryenLiteral));
    r = BinaryenConst(moduleRef, *value);
}
