#ifndef SENSOR_H
#define SENSOR_H

#include <stdio.h>
#include <string.h>

#include "pico/binary_info.h"
#include "pico/stdlib.h"
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
uint16_t *_values = 0;

void init_sensor() {
  _values = malloc(sizeof(uint16_t) * 6);
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

uint16_t *read_line() {
  read_calibrated(_values + 1);
  double avg = 0;
  double sum1 = 0;
  bool on_line = false;
  for (int i = 0; i < NUM_SENSORS; ++i) {
    uint16_t value = _values[i];
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

  _values[0] = _last_value;
}

#endif /* SENSOR_H */
