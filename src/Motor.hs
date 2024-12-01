module Motor
  ( Motor
  , init_motor
  , forward
  , backward
  , left
  , right
  , stop
  ) where
import Prelude
import Data.Maybe(fromJust)
import Pico
import PicoWrapper as PW
import Foreign.C.Types (CFloat(..))



data Motor = Motor
  { motorAin1 :: PW.GpioPin
  , motorAin2 :: PW.GpioPin
  , motorBin1 :: PW.GpioPin
  , motorBin2 :: PW.GpioPin
  , motorSlice_num_a :: PW.PwmSlice
  , motorSlice_num_b :: PW.PwmSlice
  }

ain1 :: PW.GpioPin
ain1 = fromJust $ PW.parseGpioPin 17

ain2 :: PW.GpioPin
ain2 = fromJust $ PW.parseGpioPin 18

bin1 :: PW.GpioPin
bin1 = fromJust $ PW.parseGpioPin 19

bin2 :: PW.GpioPin
bin2 = fromJust $ PW.parseGpioPin 20

pwmA :: PW.GpioPin
pwmA = fromJust $ PW.parseGpioPin 16

pwmB :: PW.GpioPin
pwmB = fromJust $ PW.parseGpioPin 21

init_motor :: IO Motor
init_motor = do
  PW.printLn "Start Init Motor"
  PW.gpioInit ain1
  PW.gpioInit ain2
  PW.gpioInit bin1
  PW.gpioInit bin2
  PW.gpioSetDir ain1 Out
  PW.gpioSetDir ain2 Out
  PW.gpioSetDir bin1 Out
  PW.gpioSetDir bin2 Out
  PW.gpioSetFunction pwmA PWM
  PW.gpioSetFunction pwmB PWM

  config <- PW.pwmGetDefaultConfig
  PW.pwmConfigSetClkDivInt config 4
  slice_a <- PW.pwmGpioToSliceNum pwmA
  slice_b <- PW.pwmGpioToSliceNum pwmB

  PW.pwmInit slice_a config True
  PW.pwmInit slice_b config True

  PW.pwmSetEnabled slice_a True
  PW.pwmSetEnabled slice_b True

  let motor = Motor { motorAin1 = ain1
                    , motorAin2 = ain2
                    , motorBin1 = bin1
                    , motorBin2 = bin2
                    , motorSlice_num_a = slice_a
                    , motorSlice_num_b = slice_b
                    }

  PW.printLn "Finished Init Motor"
  return motor

forward :: Motor -> Int -> IO ()
forward motor speed = do
  if speed >= 0 && speed <= 100
    then do
      PW.pwmSetChanLevel (motorSlice_num_a motor) PW.PwmChanA (speed*0xFFFF `div` 100)
      PW.pwmSetChanLevel (motorSlice_num_b motor) PW.PwmChanB (speed*0xFFFF `div` 100)
      PW.gpioPut (motorAin1 motor) True
      PW.gpioPut (motorAin2 motor) False
      PW.gpioPut (motorBin1 motor) False
      PW.gpioPut (motorBin2 motor) True
    else
      return ()

backward :: Motor -> Int -> IO ()
backward motor speed = do
  if speed >= 0 && speed <= 100
    then do
      PW.pwmSetChanLevel (motorSlice_num_a motor) PW.PwmChanA (speed*0xFFFF `div` 100)
      PW.pwmSetChanLevel (motorSlice_num_b motor) PW.PwmChanB (speed*0xFFFF `div` 100)
      PW.gpioPut (motorAin1 motor) False
      PW.gpioPut (motorAin2 motor) True
      PW.gpioPut (motorBin1 motor) True
      PW.gpioPut (motorBin2 motor) False
    else
      return ()

 
left :: Motor -> Int -> IO ()
left motor speed = do
  if speed >= 0 && speed <= 100
    then do
      PW.pwmSetChanLevel (motorSlice_num_a motor) PW.PwmChanA (speed*0xFFFF `div` 100)
      PW.pwmSetChanLevel (motorSlice_num_b motor) PW.PwmChanB (speed*0xFFFF `div` 100)
      PW.gpioPut (motorAin1 motor) False
      PW.gpioPut (motorAin2 motor) True
      PW.gpioPut (motorBin1 motor) False
      PW.gpioPut (motorBin2 motor) True
    else
      return ()

right :: Motor -> Int -> IO ()
right motor speed = do
  if speed >= 0 && speed <= 100
    then do
      PW.pwmSetChanLevel (motorSlice_num_a motor) PW.PwmChanA (speed*0xFFFF `div` 100)
      PW.pwmSetChanLevel (motorSlice_num_b motor) PW.PwmChanB (speed*0xFFFF `div` 100)
      PW.gpioPut (motorAin1 motor) True
      PW.gpioPut (motorAin2 motor) False
      PW.gpioPut (motorBin1 motor) True
      PW.gpioPut (motorBin2 motor) False
    else
      return ()

stop :: Motor -> IO ()
stop motor = do
  PW.pwmSetChanLevel (motorSlice_num_a motor) PW.PwmChanA 0
  PW.pwmSetChanLevel (motorSlice_num_b motor) PW.PwmChanB 0
  PW.gpioPut (motorAin1 motor) False
  PW.gpioPut (motorAin2 motor) False
  PW.gpioPut (motorBin1 motor) False
  PW.gpioPut (motorBin2 motor) False


setMotor :: Motor -> Int -> Int -> IO ()
setMotor motor left right = do
  if left >= 0 && left <= 100
    then do
      PW.gpioPut (motorAin1 motor) True
      PW.gpioPut (motorAin2 motor) False
      PW.pwmSetChanLevel (motorSlice_num_a motor) PW.PwmChanA (left*0xFFFF `div` 100)
    else
      return ()
  if left < 0 && left >= -100
    then do
      PW.gpioPut (motorAin1 motor) False
      PW.gpioPut (motorAin2 motor) True
      PW.pwmSetChanLevel (motorSlice_num_a motor) PW.PwmChanA $ negate (left*0xFFFF `div` 100)
    else
      return ()
  if right >= 0 && right <= 100
    then do
      PW.gpioPut (motorBin1 motor) True
      PW.gpioPut (motorBin2 motor) False
      PW.pwmSetChanLevel (motorSlice_num_b motor) PW.PwmChanB (right*0xFFFF `div` 100)
    else
      return ()
  if right < 0 && right >= -100
    then do
      PW.gpioPut (motorBin1 motor) False
      PW.gpioPut (motorBin2 motor) True
      PW.pwmSetChanLevel (motorSlice_num_b motor) PW.PwmChanB $ negate (right*0xFFFF `div` 100)
    else
      return ()
