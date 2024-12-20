module Sensor
  ( Sensor
  , initSensor
  , readLine
  ) where
import Prelude
import Foreign.Marshal.Array
import Foreign.Marshal.Alloc
import Foreign.Ptr

import qualified PicoWrapper as PW


data Sensor = Sensor

initSensor :: IO Sensor
initSensor = do
  PW.printLn "Init Sensor"
  c_init_sensor
  return Sensor

readLine :: Sensor -> IO (Int, [Int])
readLine _ = do
  -- ptr <- mallocArray 6 :: IO (Ptr Int)
  ptr <- c_read_line
  -- xs <- peekArray 6 ptr
  -- free ptr
  let xs = [0, 1, 2, 3, 4, 5]
  return (head xs, tail xs)


foreign import ccall "init_sensor" c_init_sensor :: IO ()
foreign import ccall "read_line"   c_read_line :: IO (Ptr Int)
