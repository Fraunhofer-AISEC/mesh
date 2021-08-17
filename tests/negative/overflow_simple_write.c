#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main()
{
  int *i = malloc(sizeof(int));
  *i = 1;
  printf("%d\n", *i);
  i[1] = 2;
  printf("%d\n", *i);
  free(i);


  return 0;
}
