#ifndef MOTOR_H
#define MOTOR_H

#include "hardware/pwm.h"
#include "pico/stdlib.h"

#define AIN1 17
#define AIN2 18
#define BIN1 19
#define BIN2 20
#define PWMA 16
#define PWMB 21

uint sliceA = 0;
uint sliceB = 0;

void motor_init() {
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

void motor_forward(int speed) {
  if (speed >= 0 && speed <= 100) {
    pwm_set_chan_level(sliceA, PWM_CHAN_A, speed * 0xFFFF / 100);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, speed * 0xFFFF / 100);
    gpio_put(AIN1, true);
    gpio_put(AIN2, false);
    gpio_put(BIN1, false);
    gpio_put(BIN2, true);
  }
}

void motor_backward(int speed) {
  if (speed >= 0 && speed <= 100) {
    pwm_set_chan_level(sliceA, PWM_CHAN_A, speed * 0xFFFF / 100);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, speed * 0xFFFF / 100);
    gpio_put(AIN1, false);
    gpio_put(AIN2, true);
    gpio_put(BIN1, true);
    gpio_put(BIN2, false);
  }
}

void motor_left(int speed) {
  if (speed >= 0 && speed <= 100) {
    pwm_set_chan_level(sliceA, PWM_CHAN_A, speed * 0xFFFF / 100);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, speed * 0xFFFF / 100);
    gpio_put(AIN1, false);
    gpio_put(AIN2, true);
    gpio_put(BIN1, false);
    gpio_put(BIN2, true);
  }
}

void motor_right(int speed) {
  if (speed >= 0 && speed <= 100) {
    pwm_set_chan_level(sliceA, PWM_CHAN_A, speed * 0xFFFF / 100);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, speed * 0xFFFF / 100);
    gpio_put(AIN1, true);
    gpio_put(AIN2, false);
    gpio_put(BIN1, true);
    gpio_put(BIN2, false);
  }
}

void motor_stop() {
  pwm_set_chan_level(sliceA, PWM_CHAN_A, 0);
  pwm_set_chan_level(sliceB, PWM_CHAN_B, 0);
  gpio_put(AIN1, false);
  gpio_put(AIN2, false);
  gpio_put(BIN1, false);
  gpio_put(BIN2, false);
}

void motor_set(int left, int right) {
  if (left >= 0 && left <= 100) {
    gpio_put(AIN1, true);
    gpio_put(AIN2, false);
    pwm_set_chan_level(sliceA, PWM_CHAN_A, (left * 0xFFFF / 100));
  } else if (left < 0 && left >= -100) {
    gpio_put(AIN1, false);
    gpio_put(AIN2, true);
    pwm_set_chan_level(sliceA, PWM_CHAN_A, -(left * 0xFFFF / 100));
  }

  if (right >= 0 && right <= 100) {
    gpio_put(BIN1, false);
    gpio_put(BIN2, true);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, (right * 0xFFFF / 100));
  } else if (right < 0 && right >= -100) {
    gpio_put(BIN1, true);
    gpio_put(BIN2, false);
    pwm_set_chan_level(sliceB, PWM_CHAN_B, -(right * 0xFFFF / 100));
  }
}

#endif /* MOTOR_H */
