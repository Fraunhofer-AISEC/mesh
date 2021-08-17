#include <stdlib.h>
#include <stdio.h>
#include <string.h>

struct FPtrStr
{
  void *(*ptr)(size_t);
};

int main()
{
  // stack
  void *(*stack_ptr)(size_t) = malloc;
  char *c = stack_ptr(2);
  c[0] = 'a';
  c[1] = '\0';
  printf("%s\n", c);
  free(c);
  
  struct FPtrStr stack_str;
  stack_str.ptr = malloc;
  char *c1 = stack_str.ptr(2);
  c1[0] = 'b';
  c1[1] = '\0';
  printf("%s\n", c1);
  free(c1);

  // heap

  struct FPtrStr *heap_str = malloc(sizeof(struct FPtrStr));
  heap_str->ptr = malloc;
  char *c2 = heap_str->ptr(2);
  c2[0] = 'b';
  c2[1] = '\0';
  printf("%s\n", c2);
  free(c2);
  free(heap_str);

  return 0;
}
