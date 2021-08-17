#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main()
{
  int *i = malloc(sizeof(int));
  *i = 1;
  printf("%d\n", *i);
  printf("%d\n", i[1]);
  free(i);


  return 0;
}
