extern int i;
int main(void);

int i = 10;
int main(void) {
  // 20170723 ld.lld 5.0.0 segfault
  // int i = 10;

  for (int k = 0; k < i; k++)
    k = i;

  return 0;
}
