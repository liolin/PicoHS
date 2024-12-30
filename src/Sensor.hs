module Sensor
  ( Sensor
  , LineColor(..)
  , initSensor
  , readLine
  ) where
import Prelude
import Foreign

import qualified PicoWrapper as PW


data Sensor = Sensor
data LineColor = Black | White

initSensor :: IO Sensor
initSensor = do
  PW.printLn "Init Sensor"
  c_init_sensor
  return Sensor

readLine :: Sensor -> LineColor -> IO (Word16, [Word16])
readLine _ color = do
  ptr <- c_read_line (isWhiteLine color) >>= newForeignPtr_
  xs <- withForeignPtr ptr myPeek
  return (head xs, tail xs)

isWhiteLine :: LineColor -> Int
isWhiteLine White = 1
isWhiteLine Black = 0

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

foreign import ccall "init_sensor" c_init_sensor :: IO ()
foreign import ccall "read_line"   c_read_line   :: Int -> IO (Ptr Word16)

