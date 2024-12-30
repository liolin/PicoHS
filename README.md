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
3. Switch the PicoGo on (switch on the underside)

![First working solution](./resources/20241230-First_Working_Solution.mp4)

## PIO / SPI
To communicate with the sensors the *Serial peripheral interface (SPI)* is used.
The Raspberry Pi Pico provides the PIO (Programmable Input/Output) to use the SPI.


## Prototypes and contributions
In order to learn how to build an application with MicroHs for an micro controller, two proof of concepts were developed.
- [Arduino Uno Prototype](./MicroHs_Contributions/arduino-uno-prototype.diff)
- [Raspberry Pi Pico Prototype](./MicroHs_Contributions/raspberry-pi-pico.diff)

During the development of this project, issues and pull requests were created for MicroHs:
- [Issue - mhs: error: no location: Not a valid C type: () #70 ](https://github.com/augustss/MicroHs/issues/70)
- [Pull Request - Remove Primitives prefix](./MicroHs_Contributions/remove_Primitives_prefix.patch)


To keep everything in one place, the diffs and patches are stored in the `MicroHs_Contributions` folder.
