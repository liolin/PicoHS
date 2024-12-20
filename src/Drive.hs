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

  motor <- initMotor
  sensor <- initSensor
  forward motor 10
  PW.printLn "Init Application Finished"
  return $ Car motor sensor

appLoop :: Car -> IO ()
appLoop car@(Car motor sensor) = do
  PW.printLn "App Loop"
  setLed True
  PW.sleepMs 1000
  setLed False
  PW.sleepMs 1000

  (position, sensorValues) <- readLine sensor

  appLoop car

setLed :: Bool -> IO ()
setLed = PW.gpioPut defaultLedPin
