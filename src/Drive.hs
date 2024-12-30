module Drive(main) where
import Prelude
import Data.Maybe(fromJust)
import Pico
import qualified PicoWrapper as PW
import Motor
import Sensor

defaultLedPin :: PW.GpioPin
defaultLedPin = fromJust $ PW.parseGpioPin 25

data Car = Car Motor Sensor

main :: IO ()
main = init >>= \car -> appLoop car

init :: IO Car
init = do
  PW.stdioInitAll
  PW.printLn "Init Application"
  PW.gpioInit defaultLedPin
  PW.gpioSetDir defaultLedPin PW.Out
  PW.sleepMs 5000

  motor <- initMotor
  sensor <- initSensor
  c_init_drive
  PW.printLn "Init Application Finished"
  return $ Car motor sensor

appLoop :: Car -> IO ()
appLoop car@(Car motor sensor) = do
  (position, sensorValues) <- readLine sensor Black
  c_one_iteration
  -- PW.sleepMs 5000
  appLoop car

setLed :: Bool -> IO ()
setLed = PW.gpioPut defaultLedPin


foreign import ccall "init_drive"    c_init_drive    :: IO ()
foreign import ccall "one_iteration" c_one_iteration :: IO ()
