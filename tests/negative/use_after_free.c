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
  memcpy(buf, "abcdef", 6);
  printf("%s\n", buf);
  free(buf);
  buf[0] = 'z';
  printf("%s\n", buf);



  return 0;
}
