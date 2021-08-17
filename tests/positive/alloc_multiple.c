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
  int *i = malloc(sizeof(int));
  *i = 1;
  printf("%d\n", *i);
  free(i);

  char *buf = malloc(128);
  memcpy(buf, "abcdef", 6);
  buf[3] = 'd';
  printf("%s\n", buf);
  free(buf);

  struct CompoundType *c = malloc(sizeof(struct CompoundType));
  c->x = 4;
  memcpy(c->buf, "abcdef", 6);
  printf("%d %s\n", c->x, c->buf);
  free(c);


  return 0;
}
