module Blinky(main) where
import Prelude

-- | The GPIO pin for the standard LED on a Raspberry Pi Pico 2040.
defaultLed :: Int
defaultLed = 25

-- | Constant indicating that the GPIO pin is being used to send a signal.
gpioOut :: Int
gpioOut = 1

-- | Constant indicating that the GPIO pin is being used to read a signal.
gpioIn :: Int
gpioIn = 0

main :: IO ()
main = init >> blinky

-- | Initializes the Raspberry Pi Pico by configuring the GPIO pin and setting up STDIO.
init :: IO ()
init = do
  c_stdio_init_all
  c_gpio_init defaultLed
  c_gpio_set_dir defaultLed gpioOut

blinky :: IO ()
blinky = do
  setLed True
  wait 5000
  setLed False
  wait 5000
  blinky

setLed :: Bool -> IO ()
setLed on = c_gpio_put defaultLed $ if on then 1 else 0

wait :: Int -> IO ()
wait = c_sleep_ms

foreign import ccall "pico/stdlib.h gpio_init"      c_gpio_init      :: Int -> IO ()
foreign import ccall "pico/stdlib.h gpio_set_dir"   c_gpio_set_dir   :: Int -> Int -> IO ()
foreign import ccall "pico/stdlib.h gpio_put"       c_gpio_put       :: Int -> Int -> IO ()
foreign import ccall "pico/stdlib.h gpio_get"       c_gpio_get       :: Int -> IO Int
foreign import ccall "pico/stdlib.h sleep_ms"       c_sleep_ms       :: Int -> IO ()
foreign import ccall "pico/stdlib.h stdio_init_all" c_stdio_init_all :: IO ()
