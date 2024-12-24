module Sensor
  ( Sensor
  , initSensor
  , readLine
  ) where
import Prelude
import Foreign.Marshal.Array
import Foreign.Marshal.Alloc
import Foreign.ForeignPtr
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
  ptr <- c_read_line >>= newForeignPtr_
  -- peekArray causes an error, but why?
  xs <- withForeignPtr ptr $ peekArray 6
  return (head xs, tail xs)


foreign import ccall "init_sensor" c_init_sensor :: IO ()
foreign import ccall "read_line"   c_read_line :: IO (Ptr Int)
