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


-- | A `Motor` is obtained by calling `init`.
-- The `Motor` serves as a token to indicate that the motor has been initialized.
data Motor = Motor

-- | Calling this function initializes the motor of the PicoGo.
-- Should only be called once. Multiple calls can lead to undesirable behavior.
init :: IO Motor
init = c_motor_init >> return Motor

-- | The car drives forward at the specified speed.
-- The car will probably not drive in a straight line because the left and right engines cannot use the power equally.
forward  :: Motor -> Int -> IO ()
forward _ = c_motor_forward

-- | The car drives backward at the specified speed.
-- The car will probably not drive in a straight line because the left and right engines cannot use the power equally.
backward :: Motor -> Int -> IO ()
backward _ = c_motor_backward

-- | The car performs a left turn.
left :: Motor -> Int -> IO ()
left _ = c_motor_left

-- | The car performs a right turn.
right :: Motor -> Int -> IO ()
right _ = c_motor_right

-- | The car stops.
stop :: Motor -> IO ()
stop _ = c_motor_stop

type LeftSpeed  = Int
type RightSpeed = Int

-- | Sets the speed for the left and right motor individually.
set :: Motor -> LeftSpeed -> RightSpeed -> IO ()
set _ = c_motor_set


foreign import ccall "motor.h motor_init"     c_motor_init     :: IO ()
foreign import ccall "motor.h motor_forward"  c_motor_forward  :: Int -> IO ()
foreign import ccall "motor.h motor_backward" c_motor_backward :: Int -> IO ()
foreign import ccall "motor.h motor_left"     c_motor_left     :: Int -> IO ()
foreign import ccall "motor.h motor_right"    c_motor_right    :: Int -> IO ()
foreign import ccall "motor.h motor_stop"     c_motor_stop     :: IO ()
foreign import ccall "motor.h motor_set"      c_motor_set      :: Int -> Int -> IO ()
