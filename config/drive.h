#ifndef DRIVE_H
#define DRIVE_H

#include <stdlib.h>
#include <time.h>

#include "hardware/clocks.h"
#include "pico/stdlib.h"

#include "motor.h"
#include "sensor.h"

int16_t integral = 0;
int16_t proportional = 0;
int16_t derivative = 0;
int16_t last_proportional = 0;
int16_t power_difference = 0;
/* int maximum = 77; */
int maximum = 30;
float p = 0.141477;
float i = 0.000637;
float d = 20.38625;

clock_t start_time_us;
clock_t end_time_us;

extern uint16_t *_values;

void init_drive() { start_time_us = clock(); }

void one_iteration() {
  double freq_khz = (double)end_time_us - start_time_us;
  freq_khz = 1 / freq_khz * 1000;

  uint16_t position = _values[0];
  uint16_t *sensor_values = _values + 1;
  uint16_t sensor_sum = 0;

  for (int i = 0; i < 5; i++) {
    sensor_sum += sensor_values[i];
  }

  if (sensor_sum < 6000) {
    // The "proportional" term should be 0 when we are on the line.
    proportional = position - 3000;

    // Compute the derivative (change) and integral (sum) of the position.
    derivative = proportional - last_proportional;
    integral += proportional;
    int16_t max_int = 5000;
    if (integral >= max_int) {
      integral = max_int;
    } else if (integral <= -max_int) {
      integral = -max_int;
    }

    // Remember the last position.
    last_proportional = proportional;

    // apply values
    power_difference = proportional * p + derivative * d + integral * i;
    // std::cout << "power_difference = " << power_difference << std::endl;

    if (power_difference > maximum) {
      power_difference = maximum;
    }

    if (power_difference < -maximum) {
      power_difference = -maximum;
    }

    if (power_difference > 0) {
      printf("%d, %d\n", maximum - power_difference, maximum);
      set_motor(maximum - power_difference, maximum);
    } else {
      printf("%d, %d\n", maximum, maximum + power_difference);
      set_motor(maximum, maximum + power_difference);
    }
  } else {
    stop();
  }
}

#endif /* DRIVE_H */
