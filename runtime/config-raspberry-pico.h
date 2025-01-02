#ifndef CONFIG_RASPERRYPICO_H
#define CONFIG_RASPERRYPICO_H

#include "hardware/clocks.h"
#include "pico/stdlib.h"
#include <stdio.h>

/*
 * Do not include STDIO as we do not have a file system on the Pico.
 */
#define WANT_STDIO 0

/*
 * Do not include directory operations as we do not have a file system on the
 * Pico.
 */
#define WANT_DIR 0

/*
 * Do not process argc and argv. We have no way of processing them on the Pico
 * anyway.
 */
#define WANT_ARGS 0

/*
 * Include MD5 checksumming code
 */
#define WANT_MD5 1

/*
 * I do not need profiling (and otherwise causes problems with WANT_STDIO 0).
 */
#define WANT_TICK 0

#define WANT_FLOAT 1
#define WANT_MATH 1
#define WANT_TIME 1

/*
 * Find First Set
 * It return the number of the least significant bit that is set.
 * Numberings starts from 1.  If no bit is set, it should return 0.
 * GCC has ffsl as a builtin.
 */
#define FFS __builtin_ffsl

/*
 * The ERR macro should report an error and exit.
 * It is the same macro as the standard macro, but writes to STDERR, although
 * WANT_STDIO is set to 0, because we have STDIO / STDERR available.
 */
#define ERR(s)                                                                 \
  do {                                                                         \
    fprintf(stderr, "ERR: "s                                                   \
                    "\n");                                                     \
    EXIT(1);                                                                   \
  } while (0)
#define ERR1(s, a)                                                             \
  do {                                                                         \
    fprintf(stderr,                                                            \
            "ERR: "s                                                           \
            "\n",                                                              \
            a);                                                                \
    EXIT(1);                                                                   \
  } while (0)

#define GCRED 1    /* do some reductions during GC */
#define FASTTAGS 1 /* compute tag by pointer subtraction */
#define INTTABLE 1 /* use fixed table of small INT nodes */
#define SANITY 1   /* do some sanity checks */
#define STACKOVL 1 /* check for stack overflow */

#define HEAP_CELLS 12000
#define STACK_SIZE 500

#define INITIALIZATION
void main_setup(void) {
  set_sys_clock_khz(133000, true);
  stdio_init_all();

  for (int i = 0; i < 10; i++) {
    printf("Starting\n");
    sleep_ms(500);
  }
}

void myexit(int n) {
  printf("Finished with code: %d\n", n);
  while (1) {
  }
}
#define EXIT myexit

#endif /* CONFIG_RASPERRYPICO_H */
