module Motor
  ( Motor
  , initMotor
  , forward
  , backward
  , left
  , right
  , stop
  ) where
import Prelude
import qualified Pico as P



data Motor = Motor

initMotor :: IO Motor
initMotor = do
  P.printLn "Start Init Motor"
  c_init_motor
  return Motor

forward  :: Motor -> Int -> IO ()
forward _ = c_forward

backward :: Motor -> Int -> IO ()
backward _ = c_backward

left :: Motor -> Int -> IO ()
left _ = c_left

right :: Motor -> Int -> IO ()
right _ = c_right

stop :: Motor -> IO ()
stop _ = c_stop

setMotor :: Motor -> Int -> Int -> IO ()
setMotor _ = c_set_motor


foreign import ccall "motor.h initMotor" c_init_motor :: IO ()
foreign import ccall "motor.h forward"   c_forward    :: Int -> IO ()
foreign import ccall "motor.h backward"  c_backward   :: Int -> IO ()
foreign import ccall "motor.h left"      c_left       :: Int -> IO ()
foreign import ccall "motor.h right"     c_right      :: Int -> IO ()
foreign import ccall "motor.h stop"      c_stop       :: IO ()
foreign import ccall "motor.h set_motor" c_set_motor  :: Int -> Int -> IO ()
