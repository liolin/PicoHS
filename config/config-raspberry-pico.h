#ifndef CONFIG_RASPERRYPICO_H
#define CONFIG_RASPERRYPICO_H

#include <stdio.h>
#include <stdlib.h>

#include "pico/stdlib.h"

void print_arr(uint16_t *values, size_t size);
void print_int(int number);

#include "drive.h"
#include "motor.h"
#include "sensor.h"

/*
 * Include stdio functions.
 * Without this none of the file I/O in System.IO is available.
 */
#define WANT_STDIO 0

/*
 * Include ops for floating point arithmetic.
 * Without this +,-,* etc will not be available for the Double type.
 */
#define WANT_FLOAT 0

/*
 * Include <math.h>
 * Without this, exp,sin, etc are not available.
 */
#define WANT_MATH 0

/*
 * Include MD5 checksumming code
 */
#define WANT_MD5 0

/*
 * Include profiling code
 */
#define WANT_TICK 0

/*
 * Process argc, argv
 */
#define WANT_ARGS 0

/*
 * Find First Set
 * This macro must be defined.
 * It return the number of the least significant bit that is set.
 * Numberings starts from 1.  If no bit is set, it should return 0.
 */
// #define FFS

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

#define GCRED 0    /* do some reductions during GC */
#define FASTTAGS 0 /* compute tag by pointer subtraction */
#define INTTABLE 0 /* use fixed table of small INT nodes */
#define SANITY 0   /* do some sanity checks */
#define STACKOVL 0 /* check for stack overflow */

/*
 * The Raspberry Pi Pico 1 has 264KB of SRAM, and 2MB of on-board flash memory.
 * So the sum of the stack and heap must be smaller than 264 * 1024 = 270336.
 * But the MicroHs runtime also requires memory. Therefore a smaller amount of
 * memory will be availabel
 */
/*
 * The allocated memory is calculated as follows:
 * HEAP_CELLS * sizeof(node) where sizeof(node) = 16
 * HEAP_CELLS * 16 = ?
 */
#define HEAP_CELLS 4000
/*
 * The allocated memory is calculated as follows:
 * sizeof(NODEPTR) * STACK_SIZE where sizeof(NODEPTR) = 8 bytes
 * STACK_SIZE * 8 = ?
 */
#define STACK_SIZE 500

#ifndef PICO_DEFAULT_LED_PIN
#define PICO_DEFAULT_LED_PIN 25
#endif /* PICO_DEFAULT_LED_PIN */

/* TODO: For debugging purposes. Remove when finished */
void print_arr(uint16_t *values, size_t size) {
  for (size_t i = 0; i < size; i++) {
    printf("%d ", values[i]);
  }
  printf("\n");
}

/* Printing number using Haskell causes an error. \
 * Dig into this error later and create a pull request. \
 */
void print_int(int number) { printf("%d", number); }

void pico_set_led(bool led_on) { gpio_put(PICO_DEFAULT_LED_PIN, led_on); }

#define INITIALIZATION
void main_setup(void) {
  set_sys_clock_khz(133000, true);
  stdio_init_all();
  gpio_init(PICO_DEFAULT_LED_PIN);
  gpio_set_dir(PICO_DEFAULT_LED_PIN, GPIO_OUT);

  for (int i = 0; i < 10; i++) {
    printf("Starting\n");
    pico_set_led(true);
    sleep_ms(250);
    pico_set_led(false);
    sleep_ms(250);
  }
}

void myexit(int n) { printf("Finished with code: %d\n", n); }
#define EXIT myexit

#endif /* CONFIG_ARDUINOUNO_H */
