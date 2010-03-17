#include <stdio.h>
#include <stdlib.h>

int fib(int n) {
  int a = 0, b = 1;
  while (n > 0) {
    int c = a + b;
    a = b;
    b = c;
    --n;
  }
  return a;
}

int main() {
  int n;
  printf("¡Hola mundo!\n");

  printf("Introduce un número: ");
  scanf("%d", &n);
  printf("fib(%d) = %d\n", n, fib(n));

  return EXIT_SUCCESS;
}
