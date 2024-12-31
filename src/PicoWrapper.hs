module PicoWrapper
  ( print
  , printLn
  , printInt
  , GpioFunctionRp2040(..)
  , castGpioFunctionRp2040
  , GpioDirection(..)
  , castGpioDirection
  , GpioPin
  , castGpioPin
  , parseGpioPin 
  , gpioInit
  , gpioSetDir 
  , gpioPut
  , gpioSetFunction
  , pwmConfigSetClkDivInt
  , pwmGpioToSliceNum
  , pwmInit
  , pwmSetEnabled
  , pwmSetChanLevel
  , PtrPwmConfig
  , PwmSlice
  , PwmChan(..)
  , sleepMs
  , stdioInitAll
  ) where
import Prelude hiding (print)
import Pico
import Foreign (Ptr)
import Foreign.C.String
import Foreign.Marshal.Alloc (free)


print :: String -> IO ()
print s = do
  cas <- newCAString s
  c_printf cas
  free cas

printLn :: String -> IO ()
printLn s = print $ s ++ "\n"

printInt :: Int -> IO ()
printInt = c_print_int

  

data GpioFunctionRp2040 = HSTX
                         | SPI
                         | UART
                         | I2C
                         | PWM
                         | SIO
                         | PIO0
                         | PIO1
                         | GPCK
                         | USB
                         | NULL

castGpioFunctionRp2040 :: GpioFunctionRp2040 -> Int
castGpioFunctionRp2040 HSTX = 0
castGpioFunctionRp2040 SPI  = 1
castGpioFunctionRp2040 UART = 2
castGpioFunctionRp2040 I2C  = 3
castGpioFunctionRp2040 PWM  = 4
castGpioFunctionRp2040 SIO  = 5
castGpioFunctionRp2040 PIO0 = 6
castGpioFunctionRp2040 PIO1 = 7
castGpioFunctionRp2040 GPCK = 8
castGpioFunctionRp2040 USB  = 9
castGpioFunctionRp2040 NULL = 0x1f


data GpioDirection = Out
                   | In
                   deriving (Eq)

castGpioDirection :: GpioDirection -> Int
castGpioDirection Out = 1
castGpioDirection In  = 0


newtype GpioPin = GpioPin Int

castGpioPin :: GpioPin -> Int
castGpioPin (GpioPin n) = n

parseGpioPin :: Int -> Maybe GpioPin
parseGpioPin n | n >= 1 && n <= 40  = Just $ GpioPin n
parseGpioPin n = Nothing

gpioInit :: GpioPin -> IO ()
gpioInit (GpioPin pin) = c_gpio_init pin

gpioSetDir :: GpioPin -> GpioDirection -> IO ()
gpioSetDir (GpioPin pin) direction = c_gpio_set_dir pin $ castGpioDirection direction

gpioPut :: GpioPin -> Bool -> IO ()
gpioPut (GpioPin pin) value = c_gpio_put pin $ if value then 1 else 0

gpioSetFunction :: GpioPin -> GpioFunctionRp2040 -> IO ()
gpioSetFunction (GpioPin pin) function = c_gpio_set_function pin (castGpioFunctionRp2040 function)

newtype PtrPwmConfig = PtrPwmConfig (Ptr PwmConfig)
newtype PwmSlice = PwmSlice Int

pwmConfigSetClkDivInt :: PtrPwmConfig -> Int -> IO ()
pwmConfigSetClkDivInt (PtrPwmConfig config) = c_pwm_config_set_clkdiv_int config

pwmGpioToSliceNum :: GpioPin -> IO PwmSlice
pwmGpioToSliceNum (GpioPin pin) = do
  slice <- c_pwm_gpio_to_slice_num pin
  return $ PwmSlice slice

pwmInit :: PwmSlice -> PtrPwmConfig -> Bool -> IO ()
pwmInit (PwmSlice slice) (PtrPwmConfig config) b = c_pwm_init slice config $ if b then 1 else 0

pwmSetEnabled :: PwmSlice -> Bool -> IO ()
pwmSetEnabled (PwmSlice slice) b = c_pwm_set_enabled slice $ if b then 1 else 0

data PwmChan = PwmChanA | PwmChanB
pwmSetChanLevel :: PwmSlice -> PwmChan -> Int -> IO ()
pwmSetChanLevel (PwmSlice slice) PwmChanA speed = c_pwm_set_chan_level slice 0 speed
pwmSetChanLevel (PwmSlice slice) PwmChanB speed = c_pwm_set_chan_level slice 1 speed


sleepMs :: Int -> IO ()
sleepMs ms = c_sleep_ms ms

stdioInitAll :: IO ()
stdioInitAll = c_stdio_init_all
