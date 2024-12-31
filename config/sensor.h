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
// [0] position
// [1..5] sensor values
uint16_t *_values = 0;

void calibrate();

/*
 * This function is used by Haskell code to get the values from _values.
 */
int get_value_with_ptr(uint16_t *ptr, int index) { return (int)ptr[index]; }

void init_sensor() {
  _values = malloc(sizeof(uint16_t) * (NUM_SENSORS + 1));
  // spi_cpha0_program is an PIO programm defined in spi.pio.
  // In spi.pio its called spi_cpha0
  uint offset = pio_add_program(PIO0, &spi_cpha0_program);
  _sm = pio_claim_unused_sm(PIO0, true);

  pio_spi_init(PIO0, _sm, offset, 12, 156.25f / 2.f, false, false, CLK_PIN,
               MOSI_PIN, MISO_PIN);

  bi_decl(bi_4pins_with_names(MISO_PIN, "SPI RX", MOSI_PIN, "SPI TX", CLK_PIN,
                              "SPI SCK", CS_PIN, "SPI CS"));

  gpio_init(CS_PIN);
  gpio_put(CS_PIN, 1);
  gpio_set_dir(CS_PIN, GPIO_OUT);

  calibrate();
}

/*
 * returnValues expected size is 5.
 */
void analog_read(uint16_t *return_values) {
  // the first read returns garbage
  uint16_t values[NUM_SENSORS + 1] = {0};
  uint offset = 0;
  for (uint32_t i = offset; i < offset + NUM_SENSORS + 1; ++i) {
    gpio_put(CS_PIN, 0);
    pio_sm_put_blocking(PIO0, _sm, i << 28);
    values[i - offset] = pio_sm_get_blocking(PIO0, _sm) & 0xfff;
    gpio_put(CS_PIN, 1);
    values[i - offset] >>= 2;
    busy_wait_us(50);
  }
  memcpy(return_values, values + 1, sizeof(uint16_t) * NUM_SENSORS);
}

void calibrate() {
  for (size_t i = 0; i < NUM_SENSORS; i++) {
    _calibrated_min[i] = 1023;
    _calibrated_max[i] = 0;
  }
  uint16_t sensor_values[6] = {0};

  for (size_t j = 0; j < 10; j++) {
    analog_read(sensor_values);
    for (size_t i = 0; i < NUM_SENSORS; i++) {
      if (_calibrated_max[i] < sensor_values[i] && sensor_values[i] != 0) {
        _calibrated_max[i] = sensor_values[i];
      }
      if (_calibrated_min[i] > sensor_values[i] && sensor_values[i] != 0) {
        _calibrated_min[i] = sensor_values[i];
      }
    }
  }
}

/*
 * sensor_values expected size is 5
 */
void read_calibrated(uint16_t *sensor_values) {
  int32_t value = 0;
  analog_read(sensor_values);

  for (int i = 0; i < NUM_SENSORS; ++i) {
    uint16_t denominator = _calibrated_max[i] - _calibrated_min[i];
    if (denominator != 0) {
      value = ((sensor_values[i] - _calibrated_min[i]) * 1000) / denominator;
    }
    if (value < 0) {
      value = 0;
    } else if (value > 1000) {
      value = 1000;
    }
    sensor_values[i] = (uint16_t)value;
  }
}

uint16_t *read_line(int white_line) {
  // _values[0] is reserved for the position of the robot relative to the line
  uint16_t *sensor_values = _values + 1;
  read_calibrated(sensor_values);
  double avg = 0;
  double sum = 0;
  bool on_line = false;

  for (int i = 0; i < NUM_SENSORS; ++i) {
    uint16_t value = sensor_values[i];
    if (white_line) {
      value = 1000 - value;
    }

    // keep track of whether we see the line at all
    // TODO: Python code has value > 200
    if (value < 800) {
      on_line = true;
    }

    // only average in values that are above a noise threshold
    if (value > 50) {
      avg += value * ((i + 1) * 1000); // this is for the weighted total,
      sum += value;                    // this is for the denominator
    }
  }

  if (on_line) {
    _successive_not_on_line = 0;
  } else {
    _successive_not_on_line++;
  }
  if (_successive_not_on_line >= _max_fails) {
    _successive_not_on_line = _max_fails;
  }

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
    if (sum != 0)
      _last_value = (uint16_t)(avg / sum);
  }

  _values[0] = _last_value;

  printf("Read from C:\t\t\t");
  print_arr(_values, NUM_SENSORS + 1);

  return _values;
}

#endif /* SENSOR_H */
