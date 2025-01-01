#ifndef CONFIG_RASPERRYPICO_H
#define CONFIG_RASPERRYPICO_H

#include "hardware/clocks.h"
#include "pico/stdlib.h"
#include <stdio.h>

/*
 * Include stdio functions.
 * Without this none of the file I/O in System.IO is available.
 */
#define WANT_STDIO 0

#define WANT_ARGS 0

/*
 * Include ops for floating point arithmetic.
 * Without this +,-,* etc will not be available for the Double type.
 */
#define WANT_FLOAT 1

/*
 * Include <math.h>
 * Without this, exp,sin, etc are not available.
 */
#define WANT_MATH 1

/*
 * Include MD5 checksumming code
 */
#define WANT_MD5 1

/*
 * Include profiling code
 */
#define WANT_TICK 0

/*
 * Include time_t type
 */
#define WANT_TIME 1

/*
 * Include directory manipulation
 */
#define WANT_DIR 0

/*
 * Find First Set
 * This macro must be defined.
 * It return the number of the least significant bit that is set.
 * Numberings starts from 1.  If no bit is set, it should return 0.
 */
/* GCC has ffsl as a builtin. */
#define FFS __builtin_ffsl


/*
 * This is the character used for comma-separation in printf.
 * Defaults to "'".
 */
/* #define PCOMMA "'" */

/*
 * Get a raw input character.
 * If undefined, the default always returns -1
 */
/* #define GETRAW */

/*
 * Get time since some epoch in milliseconds.
 */
/* #define GETTIMEMILLI */

/*
 * The ERR macro should report an error and exit.
 * If not defined, a generic one will be used.
 */
#define ERR(s)    do { fprintf(stderr,"ERR: "s"\n");   EXIT(1); } while(0)
#define ERR1(s,a) do { fprintf(stderr,"ERR: "s"\n",a); EXIT(1); } while(0)


#define GCRED    1 /* do some reductions during GC */
#define FASTTAGS 1 /* compute tag by pointer subtraction */
#define INTTABLE 1 /* use fixed table of small INT nodes */
#define SANITY   1 /* do some sanity checks */
#define STACKOVL 1 /* check for stack overflow */

// These values work for the simplified version
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
  while (1) {}
}
#define EXIT myexit

#endif /* CONFIG_RASPERRYPICO_H */
