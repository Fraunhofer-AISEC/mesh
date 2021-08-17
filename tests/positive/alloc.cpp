#include <iostream>
#include <cstring>

struct CompoundType
{
  char buf[64] = "abc";
  int x = 3;
};

int main()
{
  int *i = new int;
  *i = 1;
  std::cout << (*i)++ << '\n';
  delete i;

  char *buf = new char[128];
  memcpy(buf, "abcdef", 6);
  buf[3] = 'd';
  std::cout << buf << '\n';
  delete []buf;

  CompoundType *c = new CompoundType;
  c->x = 4;
  std::cout << c->buf << ' ' << c->x << '\n';
  delete c;

  return 0;
}
