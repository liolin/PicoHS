#ifndef CONFIG_RASPERRYPICO_H
#define CONFIG_RASPERRYPICO_H

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
/* #define ERR(s) */
/* #define ERR1(s,a) */

#define GCRED 0    /* do some reductions during GC */
#define FASTTAGS 0 /* compute tag by pointer subtraction */
#define INTTABLE 0 /* use fixed table of small INT nodes */
#define SANITY 0   /* do some sanity checks */
#define STACKOVL 0 /* check for stack overflow */

#define HEAP_CELLS 4000
#define STACK_SIZE 500

#define HASHBITS 9

#define F_CPU 16000000UL

#include "hardware/pwm.h"
#include "pico/stdlib.h"
#include <stdio.h>
#include <string.h>

// Turn the led on or off
void pico_set_led(bool led_on) {
#if defined(PICO_DEFAULT_LED_PIN)
  // Just set the GPIO on or off
  gpio_put(PICO_DEFAULT_LED_PIN, led_on);
#endif
}

pwm_config *pico_pwm_get_default_config() {
  pwm_config config = pwm_get_default_config();
  pwm_config *pconfig = malloc(sizeof(config));
  memcpy(pconfig, &config, sizeof(config));
  return pconfig;
}

#define INITIALIZATION
void main_setup(void) {
  stdio_init_all();
#ifdef PICO_DEFAULT_LED_PIN
  gpio_init(PICO_DEFAULT_LED_PIN);
  gpio_set_dir(PICO_DEFAULT_LED_PIN, GPIO_OUT);
#endif
  for (int i = 0; i < 10; i++) {
    printf("Starting\n");
    pico_set_led(true);
    sleep_ms(250);
    pico_set_led(false);
    sleep_ms(250);
  }
}

void myexit(int n) {
  while (true) {
    pico_set_led(true);
    sleep_ms(250);
    pico_set_led(false);
    sleep_ms(250);
    printf("Finished\n");
  }
}
#define EXIT myexit

#endif /* CONFIG_ARDUINOUNO_H */
