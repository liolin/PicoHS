# PicoHs
Support files to develop an MicroHs application for the Raspberry Pi Go.

## Building the project
To compile the application the following build tools must be installed (package names from Arch Linux):
```
cmake
arm-none-eabi-gcc
arm-none-eabi-newlib
```

After installing the required tools, clone the repository and change into it.
To build the application for the Raspberry Pi Pico 2040 run the following commands:
```sh
cmake -B build
cmake --build build
```
To copy the application on the Pico, press the `BOOTSEL` button while powering on.
This will mount the Pico as an USB device.
Now you can copy the application to the Pico:
```sh
cp build/pico-go.uf2 <pico-mount-point>
```


After changes to the source code it is enough to run `cmake --build build` again.
In case you changed something in the cmake files, you have to run `cmake -B build` again followed by `cmake --build build`.

## Monitor console / Debugging
`PicoWrapper.hs` provides `print` and `printLn`.
These two functions can be used to log to the console.
After you connected the Pico using USB to your PC, you can connect to the console using `minicom`:
```sh
minicom -b 115200 -o -D /dev/ttyACM0
```

## Run PicoGo
1. Copy application to the PicoGo
2. Unplug USB Cable
3. Turn the PicoGo on (switch on the bottom side)
