#ifndef HELPERS_H
#define HELPERS_H

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

/* TODO: For debugging purposes. Remove when finished */
void print_arr(uint16_t *values, size_t size) {
  for (size_t i = 0; i < size; i++) {
    printf("%d ", values[i]);
  }
  printf("\n");
}

/* Printing number using Haskell causes an error.
 * Dig into this error later and create a pull request.
 */
void print_int(int number) { printf("%d", number); }

#endif /* HELPERS_H */
