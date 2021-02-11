#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#define coarse __attribute__((coarsecf_check))

void test_cet_bits(void);
void foo(void);


void coarse cet_set_1() {
  fprintf(stderr, "CET: 0x1 SET\n");
}

void coarse cet_not_set_1() {
  fprintf(stderr, "CET: 0x1 NOT SET\n");
}

void coarse cet_set_2() {
  fprintf(stderr, "CET: 0x2 SET\n");
}

void coarse cet_not_set_2() {
  fprintf(stderr, "CET: 0x2 NOT SET\n");
}

void coarse cet_set_4() {
  fprintf(stderr, "CET: 0x4 SET\n");
}

void coarse cet_not_set_4() {
  fprintf(stderr, "CET: 0x4 NOT SET\n");
}

void coarse cet_set_8() {
  fprintf(stderr, "CET: 0x8 SET\n");
}

void coarse cet_not_set_8() {
  fprintf(stderr, "CET: 0x8 NOT SET\n");
}

void coarse cet_set_10() {
  fprintf(stderr, "CET: 0x10 SET\n");
}

void coarse cet_not_set_10() {
  fprintf(stderr, "CET: 0x10 NOT SET\n");
}

int main() {
  void *ptr = NULL;
  test_cet_bits();
  ptr = dlopen("libfoocoarse.so", RTLD_NOW);
  if (!ptr) {
    fprintf(stderr, "could not open libfoocoarse.so, "
                    "run with: GLIBC_TUNABLES=glibc.cpu.x86_ibt=permissive\n");
  } else {
    fprintf(stderr, "libfoocoarse.so loaded\n");
  }
  test_cet_bits();
  ptr = dlopen("libfoonocfi.so", RTLD_NOW);
  if (!ptr) {
    fprintf(stderr, "could not open libfoonocfi.so, "
                    "run with: GLIBC_TUNABLES=glibc.cpu.x86_ibt=permissive\n");
  } else {
    fprintf(stderr, "libfoonocfi.so loaded\n");
  }
  test_cet_bits();
  foo();
}
