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

extern uint16_t *_values;

void init_drive() {}

void one_iteration() {
  uint16_t position = _values[0];
  uint16_t *sensor_values = _values + 1;
  uint16_t sensor_sum = 0;

  for (int i = 0; i < NUM_SENSORS; i++) {
    sensor_sum += sensor_values[i];
  }

  // Python: sensor_sum > 4000
  if (sensor_sum > 5000) {
    stop();
  } else {
    // The "proportional" term should be 0 when we are on the line.
    // Python: propprtional = position - 2000;
    proportional = position - 3000;

    // Compute the derivative (change) and integral (sum) of the position.
    derivative = proportional - last_proportional;
    integral += proportional;

    // Python: does not exits
    // to ensure that no overflow can happen?
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
    /* power_difference = proportional / 30 + derivative * 2; */

    if (power_difference > maximum) {
      power_difference = maximum;
    }

    if (power_difference < -maximum) {
      power_difference = -maximum;
    }
    printf("power_difference:\t\t%d, ", power_difference);

    if (power_difference < 0) {
      printf("%d, %d\n", maximum + power_difference, maximum);
      /* set_motor(maximum + power_difference, maximum); */
    } else {
      printf("%d, %d\n", maximum, maximum - power_difference);
      /* set_motor(maximum, maximum - power_difference); */
    }
  }
}

#endif /* DRIVE_H */
