#include <stdio.h>
#include <stdlib.h>

unsigned long int tcalls = 0;

void swap(int array[], int a, int b)
{
	tcalls++;
	int aux = array[a];
	array[a] = array[b];
	array[b] = aux;
}
