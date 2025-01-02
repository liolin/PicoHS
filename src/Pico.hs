module Pico( print
           , printLn
           , sleepMs
           ) where
import Prelude hiding (print)
import Foreign.C.String (CString, newCAString)
import Foreign.Marshal.Alloc (free)

-- | Prints a given string to STDIO with C's `printf`.
-- Since STDIO is disabled in MicroHs, I offer this escape hatch.
print :: String -> IO ()
print s = do
  cas <- newCAString s
  c_printf cas
  free cas

-- | Prints a given string to STDIO with a new line appended.
printLn :: String -> IO ()
printLn s = print $ s ++ "\n"

-- | Pauses the current execution for the specified number of milliseconds.
sleepMs :: Int -> IO ()
sleepMs = c_sleep_ms

foreign import ccall "pico/stdlib.h sleep_ms" c_sleep_ms  :: Int    -> IO ()
foreign import ccall "printf"                 c_printf    :: CString -> IO ()
