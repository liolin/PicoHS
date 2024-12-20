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
  ptr <- mallocArray 6
  c_read_line ptr
  xs <- peekArray 6 ptr
  free ptr

  return (head xs, tail xs)


foreign import ccall "init_sensor" c_init_sensor :: IO ()
foreign import ccall "read_line"   c_read_line :: Ptr Int -> IO ()
