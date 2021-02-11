#include <stdio.h>
#include <stdlib.h>

extern unsigned long tcalls;

void fill(int array[], int n, int m);

extern void swap(int array[], int a, int b);

void (*SW)(int array[], int a, int b) = &swap;

void print_array(int array[], int n)
{
	fprintf(stderr, "OUTPUT: ARRAY(%d):", n);
	for (int i = 0; i < n; i++)
		fprintf(stderr, " %d", array[i]);
	fprintf(stderr, "\n");
}

void bsort(int array[], int n)
{
	int i, j;
	for (i = 0; i < n - 1; i++)
		for (j = 0; j < n - 1 - i; j++)
			if (array[j] > array[j+1])
				SW(array, j, j + 1);
}

int main(int argc, char *argv[])
{
	if (argc != 2)
	{
		fprintf(stderr, "USAGE: %s <n>\n", argv[0]);
		exit(1);
	}

	int n = atoi(argv[1]);
	int *array = calloc(n, sizeof(int));
	fill(array, n, 23);

  fprintf(stderr, "before: ");
  for (unsigned int i = 0; i < n; i++) {
    fprintf(stderr, "%d ", array[i]);
  }
  fprintf(stderr, "\n");
	bsort(array, n);
  fprintf(stderr, "after: ");
  for (unsigned int i = 0; i < n; i++) {
    fprintf(stderr, "%d ", array[i]);
  }
  fprintf(stderr, "\n");
	fprintf(stderr, "input %d\n", n);
	fprintf(stderr, "tcalls %lu\n", tcalls);
}
