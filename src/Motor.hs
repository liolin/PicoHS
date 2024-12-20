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
import qualified PicoWrapper as PW



data Motor = Motor

initMotor :: IO Motor
initMotor = do
  PW.printLn "Start Init Motor"
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


foreign import ccall "initMotor" c_init_motor :: IO ()
foreign import ccall "forward"   c_forward    :: Int -> IO ()
foreign import ccall "backward"  c_backward   :: Int -> IO ()
foreign import ccall "left"      c_left       :: Int -> IO ()
foreign import ccall "right"     c_right      :: Int -> IO ()
foreign import ccall "stop"      c_stop       :: IO ()
foreign import ccall "set_motor" c_set_motor  :: Int -> Int -> IO ()
