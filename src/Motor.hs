module Motor
  ( Motor
  , init
  , forward
  , backward
  , left
  , right
  , stop
  , set
  ) where
import Prelude
import qualified Pico as P



data Motor = Motor

init :: IO Motor
init = do
  P.printLn "Start Init Motor"
  c_motor_init
  return Motor

forward  :: Motor -> Int -> IO ()
forward _ = c_motor_forward

backward :: Motor -> Int -> IO ()
backward _ = c_motor_backward

left :: Motor -> Int -> IO ()
left _ = c_motor_left

right :: Motor -> Int -> IO ()
right _ = c_motor_right

stop :: Motor -> IO ()
stop _ = c_motor_stop

set :: Motor -> Int -> Int -> IO ()
set _ = c_motor_set


foreign import ccall "motor.h motor_init"     c_motor_init     :: IO ()
foreign import ccall "motor.h motor_forward"  c_motor_forward  :: Int -> IO ()
foreign import ccall "motor.h motor_backward" c_motor_backward :: Int -> IO ()
foreign import ccall "motor.h motor_left"     c_motor_left     :: Int -> IO ()
foreign import ccall "motor.h motor_right"    c_motor_right    :: Int -> IO ()
foreign import ccall "motor.h motor_stop"     c_motor_stop     :: IO ()
foreign import ccall "motor.h motor_set"      c_motor_set      :: Int -> Int -> IO ()
