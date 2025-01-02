module Drive(main) where
import Prelude
import Data.Ord(clamp)
import qualified Pico as P
import qualified Motor as M
import qualified Sensor as S
import Motor (Motor)
import Sensor (Sensor, LineColor(..))

data Car = Car Motor Sensor

type Proportional = Int
-- TODO: Better name
type Integ        = Int
type Position     = Int
type State        = (Proportional, Integ)

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

-- | Initialize the car by initializing the motor and the sensor.
-- | It waits for 5s, so that the car can be placed on the floor before initialization starts.
initCar :: IO Car
initCar = do
  P.printLn "Init Application"
  P.sleepMs 5000
  motor <- M.init
  sensor <- S.init
  P.printLn "Init Application Finished"
  return $ Car motor sensor

-- | The app loop: reading sensor values, calculating power for motors, setting motors, repeat.
appLoop :: Car -> State -> IO ()
appLoop car@(Car motor sensor) st = do
  (position, _) <- S.readLine sensor Black
  let (pd, st') = update st position
  uncurry (M.set motor) (calcMotorConfig pd)
  appLoop car st'

-- | Calculates the motor config and returns it as a tuple (left motor, right motor).
calcMotorConfig :: Int -> (Int, Int)
calcMotorConfig pd = if pd < 0 then (maxSpeed + pd, maxSpeed) else (maxSpeed, maxSpeed - pd)

-- | Updates the State and returns the power difference.
update :: State -> Position -> (Int, State)
update (prop, int) pos = (pd, (p, i))
  where
    p  = calcProportional pos
    d  = calcDerivative prop p
    i  = calcIntegral int p
    pd = calcPowerDifference p d i

-- | Calculates the proportional position from the given position.
calcProportional :: Int -> Int
calcProportional position = position - 3000

-- | Calculates the change by x0 - x1
calcDerivative :: Int -> Int -> Int
calcDerivative x0 x1 = x1 - x0

-- | Calculates the new integral from the old one with the given proportional position.
calcIntegral :: Int -> Int -> Int
calcIntegral x0 v = clamp (-5000, 5000) x0 + v

-- | Calculates the power difference for the motors.
calcPowerDifference :: Int -> Int -> Int -> Int
calcPowerDifference proportional derivative integral = clamp (-maxSpeed, maxSpeed) $ prop + der + int
  where
    toInt = fromInteger . truncate
    prop = toInt $ fromIntegral proportional * p
    der = toInt $ fromIntegral derivative * d
    int  = toInt $ fromIntegral integral * i
