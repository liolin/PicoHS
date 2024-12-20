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

#define AIN1 17
#define AIN2 18
#define BIN1 19
#define BIN2 20
#define PWMA 16
#define PWMB 21

uint sliceA = 0;
uint sliceB = 0;

void initMotor() {
  gpio_init(AIN1);
  gpio_init(AIN2);
  gpio_init(BIN1);
  gpio_init(BIN2);
  gpio_set_dir(AIN1, GPIO_OUT);
  gpio_set_dir(AIN2, GPIO_OUT);
  gpio_set_dir(BIN1, GPIO_OUT);
  gpio_set_dir(BIN2, GPIO_OUT);
  gpio_set_function(PWMA, GPIO_FUNC_PWM);
  gpio_set_function(PWMB, GPIO_FUNC_PWM);

  pwm_config config = pwm_get_default_config();
  pwm_config_set_clkdiv(&config, 4.0);
  sliceA = pwm_gpio_to_slice_num(PWMA);
  sliceB = pwm_gpio_to_slice_num(PWMB);

  pwm_init(sliceA, &config, true);
  pwm_init(sliceB, &config, true);

  pwm_set_enabled(sliceA, true);
  pwm_set_enabled(sliceB, true);
}

void forward(int speed) {
  if (speed >= 0 && speed <= 100) {
    pwm_set_chan_level(sliceA, PWM_CHAN_A, speed * 0xFFFF / 100);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, speed * 0xFFFF / 100);
    gpio_put(AIN1, true);
    gpio_put(AIN2, false);
    gpio_put(BIN1, false);
    gpio_put(BIN2, true);
  }
}

void backward(int speed) {
  if (speed >= 0 && speed <= 100) {
    pwm_set_chan_level(sliceA, PWM_CHAN_A, speed * 0xFFFF / 100);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, speed * 0xFFFF / 100);
    gpio_put(AIN1, false);
    gpio_put(AIN2, true);
    gpio_put(BIN1, true);
    gpio_put(BIN2, false);
  }
}

void left(int speed) {
  if (speed >= 0 && speed <= 100) {
    pwm_set_chan_level(sliceA, PWM_CHAN_A, speed * 0xFFFF / 100);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, speed * 0xFFFF / 100);
    gpio_put(AIN1, false);
    gpio_put(AIN2, true);
    gpio_put(BIN1, false);
    gpio_put(BIN2, true);
  }
}

void right(int speed) {
  if (speed >= 0 && speed <= 100) {
    pwm_set_chan_level(sliceA, PWM_CHAN_A, speed * 0xFFFF / 100);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, speed * 0xFFFF / 100);
    gpio_put(AIN1, true);
    gpio_put(AIN2, false);
    gpio_put(BIN1, true);
    gpio_put(BIN2, false);
  }
}

void stop() {
  pwm_set_chan_level(sliceA, PWM_CHAN_A, 0);
  pwm_set_chan_level(sliceB, PWM_CHAN_B, 0);
  gpio_put(AIN1, false);
  gpio_put(AIN2, false);
  gpio_put(BIN1, false);
  gpio_put(BIN2, false);
}

void set_motor(int left, int right) {
  if (left >= 0 && left <= 100) {
    gpio_put(AIN1, true);
    gpio_put(AIN2, false);
    pwm_set_chan_level(sliceA, PWM_CHAN_A, (left * 0xFFFF / 100));
  }

  if (left < 0 && left >= -100) {
    gpio_put(AIN1, false);
    gpio_put(AIN2, true);
    pwm_set_chan_level(sliceA, PWM_CHAN_A, -(left * 0xFFFF / 100));
  }

  if (right >= 0 && right <= 100) {
    gpio_put(BIN1, true);
    gpio_put(BIN2, false);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, (right * 0xFFFF / 100));
  }

  if (right < 0 && right >= -100) {
    gpio_put(BIN1, false);
    gpio_put(BIN2, true);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, -(right * 0xFFFF / 100));
  }
}

#include "pico/binary_info.h"
#include "spi.pio.h"

#define NUM_SENSORS 5
#define PIO0 pio0
#define BUFFER_SIZE 8
#define CLK_PIN 6
#define MOSI_PIN 7
#define MISO_PIN 27
#define CS_PIN 28

uint _sm = 0;
uint _successive_not_on_line = 0;
uint _max_fails = 20;
uint16_t _last_value = 0;
uint16_t _calibrated_min[5] = {117, 129, 124, 127, 101};
uint16_t _calibrated_max[5] = {841, 899, 925, 945, 823};

void init_sensor() {
  uint offset = pio_add_program(PIO0, &spi_cpha0_program);
  _sm = pio_claim_unused_sm(PIO0, true);

  pio_spi_init(PIO0, _sm, offset, 12, 156.25f / 2.f, false, false, CLK_PIN,
               MOSI_PIN, MISO_PIN);

  bi_decl(bi_4pins_with_names(MISO_PIN, "SPI RX", MOSI_PIN, "SPI TX", CLK_PIN,
                              "SPI SCK", CS_PIN, "SPI CS"));

  gpio_init(CS_PIN);
  gpio_put(CS_PIN, 1);
  gpio_set_dir(CS_PIN, GPIO_OUT);
}

void analog_read(uint16_t *returnValues) {
  uint16_t value[NUM_SENSORS + 1] = {0};
  uint offset = 0;
  for (uint32_t i = offset; i < offset + NUM_SENSORS + 1; ++i) {
    gpio_put(CS_PIN, 0);
    pio_sm_put_blocking(PIO0, _sm, i << 28);
    value[i - offset] = pio_sm_get_blocking(PIO0, _sm) & 0xfff;
    gpio_put(CS_PIN, 1);
    value[i - offset] >>= 2;
    busy_wait_us(50);
  }

  memcpy(returnValues, value, NUM_SENSORS);
}

void read_calibrated(uint16_t *sensor_values) {
  uint16_t value = 0;
  analog_read(sensor_values);

  for (int i = 0; i < NUM_SENSORS; ++i) {
    uint16_t denominator = _calibrated_max[i] - _calibrated_min[i];
    if (denominator != 0)
      value = (sensor_values[i] - _calibrated_min[i]) * 1000 / denominator;
    if (value < 0)
      value = 0;
    else if (value > 1000)
      value = 1000;
    sensor_values[i] = (uint16_t)value;
  }
}

void read_line(uint16_t *values) {
  read_calibrated(values + 1);
  double avg = 0;
  double sum1 = 0;
  bool on_line = false;
  for (int i = 0; i < NUM_SENSORS; ++i) {
    uint16_t value = values[i];
    /* if (white_line) */
    /*   value = 1000 - value; */

    // keep track of whether we see the line at all
    if (value < 800)
      on_line = true;

    // only average in values that are above a noise threshold
    if (value > 50)
      avg += value * ((i + 1) * 1000); // this is for the weighted total,
    sum1 += value;                     // this is for the denominator
  }

  if (on_line)
    _successive_not_on_line = 0;
  else
    _successive_not_on_line++;
  if (_successive_not_on_line >= _max_fails)
    _successive_not_on_line = _max_fails;

  if (_successive_not_on_line >= _max_fails) {
    // std::cout << "not on line" << std::endl;
    //  If last read to the left of center, return min.
    if (_last_value < 3050) {
      // std::cout << "left" << std::endl;
      _last_value = 2500;
    }
    // If last read to the right of center, return the max.
    else {
      // std::cout << "right" << std::endl;
      _last_value = 3500;
    }
  }

  if (on_line) {
    // std::cout << "on line" << std::endl;
    if (sum1 != 0)
      _last_value = (uint16_t)(avg / sum1);
  }

  values[0] = _last_value;
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
