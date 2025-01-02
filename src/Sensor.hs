module Sensor
  ( Sensor
  , LineColor(..)
  , init
  , readLine
  ) where
import Prelude
import Foreign
import Control.Monad (mapM)

data Sensor = Sensor
data LineColor = Black | White

init :: IO Sensor
init = c_sensor_init >> return Sensor

-- | Calls the C function to read the IR sensors.
readLine :: Sensor -> LineColor -> IO (Int, [Int])
readLine _ color = do
  ptr <- c_sensor_read_line (isWhiteLine color) >>= newForeignPtr_
  xs <- withForeignPtr ptr getReadLineValuesWithPtr
  return (head xs, tail xs)

isWhiteLine :: LineColor -> Int
isWhiteLine White = 1
isWhiteLine Black = 0

-- | Reads 5 Ints from the given pointer. It does the same as peek should do, but with peek I read garbage.
getReadLineValuesWithPtr :: Ptr Word16 -> IO [Int]
getReadLineValuesWithPtr ptr = mapM (c_get_value_with_ptr ptr) [0..5]

foreign import ccall "sensor.h sensor_init"          c_sensor_init        :: IO ()
foreign import ccall "sensor.h sensor_read_line"     c_sensor_read_line   :: Int -> IO (Ptr Word16)
foreign import ccall "sensor.h get_value_with_ptr"   c_get_value_with_ptr :: Ptr Word16 -> Int -> IO Int
