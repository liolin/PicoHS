module Pico( print
           , printLn
           , printInt
           , sleepMs
           ) where
import Prelude hiding (print)
import Foreign (Ptr)
import Foreign.C.Types (CFloat)
import Foreign.C.String (CString, newCAString)
import Foreign.Marshal.Alloc (free)

print :: String -> IO ()
print s = do
  cas <- newCAString s
  c_printf cas
  free cas

printLn :: String -> IO ()
printLn s = print $ s ++ "\n"

printInt :: Int -> IO ()
printInt = c_print_int

sleepMs :: Int -> IO ()
sleepMs = c_sleep_ms

foreign import ccall "pico/stdlib.h sleep_ms" c_sleep_ms  :: Int    -> IO ()
foreign import ccall "printf"                 c_printf    :: CString -> IO ()
foreign import ccall "print_int"              c_print_int :: Int -> IO ()
