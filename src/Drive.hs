module Drive(main) where
import Prelude
import Data.Maybe(fromJust)
import Pico
import qualified PicoWrapper as PW
import Motor

defaultLedPin :: PW.GpioPin
defaultLedPin = fromJust $ PW.parseGpioPin 25

main :: IO ()
main = do
  motor <- init
  appLoop motor

init :: IO Motor
init = do
  PW.stdioInitAll
  PW.printLn "Init Application"
  PW.gpioInit defaultLedPin
  PW.gpioSetDir defaultLedPin PW.Out
  motor <- initMotor
  forward motor 10
  PW.printLn "Init Application Finished"
  return motor

appLoop :: Motor -> IO ()
appLoop motor = do
  PW.printLn "App Loop"
  setLed True
  PW.sleepMs 1000
  setLed False
  PW.sleepMs 1000
  appLoop motor

setLed :: Bool -> IO ()
setLed on = PW.gpioPut defaultLedPin on
