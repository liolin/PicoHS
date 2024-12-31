module Sensor
  ( Sensor
  , LineColor(..)
  , initSensor
  , readLine
  ) where
import Prelude
import Foreign
import Control.Monad (mapM)

import qualified PicoWrapper as PW


data Sensor = Sensor
data LineColor = Black | White

initSensor :: IO Sensor
initSensor = do
  PW.printLn "Init Sensor"
  c_init_sensor
  return Sensor

readLine :: Sensor -> LineColor -> IO (Int, [Int])
readLine _ color = do
  ptr <- c_read_line (isWhiteLine color) >>= newForeignPtr_
  PW.print "Read from Haskell:\t\t"
  xs <- withForeignPtr ptr getReadLineValuesWithPtr >>= mapM (\v -> PW.printInt v >> PW.print " " >> return v)
  PW.printLn ""
  return (head xs, tail xs)

isWhiteLine :: LineColor -> Int
isWhiteLine White = 1
isWhiteLine Black = 0

getReadLineValuesWithPtr :: Ptr Word16 -> IO [Int]
getReadLineValuesWithPtr ptr = do
  -- forM crashes with bad n, why?
  -- forM [0..5] c_get_value
  v0 <- c_get_value_with_ptr ptr 0
  v1 <- c_get_value_with_ptr ptr 1
  v2 <- c_get_value_with_ptr ptr 2
  v3 <- c_get_value_with_ptr ptr 3
  v4 <- c_get_value_with_ptr ptr 4
  v5 <- c_get_value_with_ptr ptr 5
  return [v0, v1, v2, v3, v4, v5]

-- Reads wrong memory address.
-- but why?, maybe wrong pointer size?
myPeek :: Ptr Word16 -> IO [Word16]
myPeek p1 = do
  v1 <- peek p1
  let p2 = plusPtr p1 1
  v2 <- peek p2
  let p3 = plusPtr p2 1
  v3 <- peek p3
  let p4 = plusPtr p3 1
  v4 <- peek p4
  let p5 = plusPtr p4 1
  v5 <- peek p5
  let p6 = plusPtr p5 1
  v6 <- peek p6
  return [v1, v2, v3, v4, v5, v6]

foreign import ccall "init_sensor"          c_init_sensor :: IO ()
foreign import ccall "read_line"            c_read_line   :: Int -> IO (Ptr Word16)
foreign import ccall "get_value_with_ptr"   c_get_value_with_ptr  :: Ptr Word16 -> Int -> IO Int
