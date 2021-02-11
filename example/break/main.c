#include <stdio.h>

void foo(void);

int main() {
	void (*F)(void);
	F = &foo;
	F();
	printf("OK\n");
}
