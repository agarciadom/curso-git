#include <stdio.h>
#include <stdlib.h>
#include "fib.h"

int main() {
  int n;
  printf("Introduce un número: ");
  scanf("%d", &n);
  printf("fib(%d) = %d\n", n, fib(n));

  return EXIT_SUCCESS;
}
