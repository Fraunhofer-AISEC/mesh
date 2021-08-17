#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct CompoundType
{
  char buf[64];
  int x;
};

int main()
{
  char *buf = malloc(128);
  //memcpy(buf, "abcdef", 6);
  //printf("buf: %p %s\n", buf, buf);

  char *unprotected = &buf[0];
  unprotected = (char *)((size_t)unprotected & 0x0000FFFFFFFFFFFFULL);
  printf("unprotected %p\n", unprotected);
  buf[1] = 'a';
  unprotected[0] = 'z';
  printf("%s\n", unprotected);


  free(buf);



  return 0;
}
