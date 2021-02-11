#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void fill(int array[], int n, int seed)
{
	memset(array, 0x00, n);
	srand(seed);
	for (int i = 0; i < n; i++) {
		array[i] = rand() % 1000000;
	}
}
