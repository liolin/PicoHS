module Pico( c_gpio_init
           , c_gpio_set_dir
           , c_gpio_set_function
           , c_gpio_put
           , c_gpio_get
           , c_sleep_ms

           , c_pico_pwm_get_default_config
           -- , c_pwm_config_set_clkdiv
           , c_pwm_config_set_clkdiv_int
           , c_pwm_gpio_to_slice_num
           , c_pwm_init
           , c_pwm_set_enabled
           , c_pwm_set_chan_level
           , PwmConfig

           , c_stdio_init_all
           , c_printf
           ) where
import Prelude
import Foreign(Ptr)
import Foreign.C.Types (CFloat)
import Foreign.C.String

foreign import ccall "pico/stdlib.h gpio_init"         c_gpio_init         :: Int    -> IO ()
foreign import ccall "pico/stdlib.h gpio_set_dir"      c_gpio_set_dir      :: Int    -> Int -> IO ()
foreign import ccall "pico/stdlib.h gpio_set_function" c_gpio_set_function :: Int    -> Int -> IO ()
foreign import ccall "pico/stdlib.h gpio_put"          c_gpio_put          :: Int    -> Int -> IO ()
foreign import ccall "pico/stdlib.h gpio_get"          c_gpio_get          :: Int    -> IO Int
foreign import ccall "pico/stdlib.h sleep_ms"          c_sleep_ms          :: Int    -> IO ()

foreign import ccall "pico_pwm_get_default_config" c_pico_pwm_get_default_config    :: IO (Ptr PwmConfig)
-- foreign import ccall "hardware/pwm.h pwm_config_set_clkdiv" c_pwm_config_set_clkdiv :: Ptr PwmConfig -> Float -> IO ()
foreign import ccall "hardware/pwm.h pwm_config_set_clkdiv_int" c_pwm_config_set_clkdiv_int :: Ptr PwmConfig -> Int -> IO ()
foreign import ccall "hardware/pwm.h pwm_gpio_to_slice_num" c_pwm_gpio_to_slice_num :: Int -> IO Int
foreign import ccall "hardware/pwm.h pwm_init"              c_pwm_init :: Int -> Ptr PwmConfig -> Int -> IO ()
foreign import ccall "hardware/pwm.h pwm_set_enabled"       c_pwm_set_enabled :: Int -> Int -> IO ()
foreign import ccall "hardware/pwm.h pwm_set_chan_level"    c_pwm_set_chan_level :: Int -> Int -> Int -> IO ()


foreign import ccall "pico/stdlib.h stdio_init_all" c_stdio_init_all    :: IO ()
foreign import ccall "printf"                       c_printf            :: CString -> IO ()


data PwmConfig = PwmConfig
