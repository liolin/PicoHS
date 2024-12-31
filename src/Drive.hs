module Drive(main) where
import Prelude
import Data.Maybe(fromJust)
import Data.Ord(clamp)
import Pico
import qualified PicoWrapper as PW
import Motor
import Sensor

data Car = Car Motor Sensor

type Proportional = Int
-- TODO: Better name
type Integ        = Int
type Position     = Int
type State        = (Proportional, Integ)

defaultLedPin :: PW.GpioPin
defaultLedPin = fromJust $ PW.parseGpioPin 25

p :: Float
p = 0.141477

i :: Float
i = 0.000637

d :: Float
d = 20.38625;

maxSpeed :: Int
maxSpeed = 30

startState :: State
startState = (0, 0)

main :: IO ()
main = initCar >>= \car -> appLoop car (0, 0)

initCar :: IO Car
initCar = do
  PW.stdioInitAll
  PW.printLn "Init Application"
  PW.gpioInit defaultLedPin
  PW.gpioSetDir defaultLedPin PW.Out
  PW.sleepMs 5000

  motor <- initMotor
  sensor <- initSensor
  PW.printLn "Init Application Finished"
  return $ Car motor sensor

appLoop :: Car -> State -> IO ()
appLoop car@(Car motor sensor) st = do
  (position, sensorValues) <- readLine sensor Black
  c_one_iteration
  -- let sensorSum = sum sensorValues
  -- let st' = update st position
  -- PW.print "Haskell: "
  -- PW.printInt (fst st')
  -- PW.printLn ""
  PW.sleepMs 5000
  appLoop car st

update :: State -> Position -> (Int, State)
update (prop, int) pos = (pd, (p, i))
  where
    p  = calcProportional pos
    d  = calcDerivative prop p
    i  = calcIntegral int p
    pd = calcPowerDifference p d i

-- | Calculates the proportional position from the given position
calcProportional :: Int -> Int
calcProportional position = position - 3000

-- | Calculates the change by x0 - x1
calcDerivative :: Int -> Int -> Int
calcDerivative x0 x1 = x1 - x0

-- | Calculates the new integral from the old one with the given proportional position
calcIntegral :: Int -> Int -> Int
calcIntegral x0 v = clamp (-5000, 5000) x0 + v

-- | Calculates the power difference for the motors
calcPowerDifference :: Int -> Int -> Int -> Int
calcPowerDifference proportional derivative integral = prop + der + int
  where
    toInt = fromInteger . truncate
    prop = toInt $ fromIntegral proportional * p
    der = toInt $ fromIntegral derivative * d
    int  = toInt $ fromIntegral integral * i

setLed :: Bool -> IO ()
setLed = PW.gpioPut defaultLedPin

foreign import ccall "one_iteration" c_one_iteration :: IO ()
