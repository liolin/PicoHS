# PicoHs
A line following algorithm implemented with MicroHs for the Raspberry Pi Go powered by a Raspberry Pi Pico.

## Building the project
To compile the application, the following build tools must be installed (package names from Arch Linux):

```
cmake
arm-none-eabi-gcc
arm-none-eabi-newlib
```

### Raspberry Pi Pico 2040
To build the application for the Raspberry Pi Pico 2040, execute the following commands:
```sh
cmake -B build
cmake --build build
```

### Raspberry Pi Pico 2040 W
To build the application for the Raspberry Pi Pico W, execute the following commands:
```sh
cmake -B build -DPICO_BOARD=pico_w -DWIFI_SSID="Your Network" -DWIFI_PASSWORD="Your Password"
cmake --build build
```

The options `-DWIFI_*` can be omitted if you do not intend to use WiFi.

### Raspberry Pi Pico 2350
To build the application for the Raspberry Pi Pico 2350, execute the following commands:
```sh
cmake -B build -DPICO_PLATFORM=rp2350
cmake --build build
```

## Flashing
To copy the application to the Pico, press the `BOOTSEL` button when switching on.
This will mount the Pico as a USB device.
You can now copy the application to the Pico:
```sh
cp build/pico-go.uf2 <pico-mount-point>
```

After making changes to the source code, it is sufficient to execute `cmake --build build` again.
If you have changed anything in the cmake files, you need to execute `cmake -B build` (see build instructions for your platform) again, followed by `cmake --build build`.

## Monitor console / Debugging
The `Pico.hs` module provides the `print` and `printLn` functions.
These two functions can be used to log to the console.
Once you have connected the Pico to your PC via USB and copied the program, you can use `minicom` to connect to the Pico's console:
```sh
minicom -b 115200 -o -D /dev/ttyACM0
```

## Run PicoGo
1. Copy the application to the PicoGo
2. Unplug USB Cable
3. Switch the PicoGo on (switch on the underside)

It is recommended to place the PicoGo on a white paper with a black line during initialization.
The PicoGo will drive better on the line.

![First working solution](./resources/20241230-First_Working_Solution.mp4)
![Second working solution](./resources/20250102-Second_Working_Solution.mp4)

## PIO / SPI
To communicate with the sensors the *Serial peripheral interface (SPI)* is used.
The Raspberry Pi Pico provides the PIO (Programmable Input/Output) to use the SPI.

## Prototypes and contributions
In order to learn how to build an application with MicroHs for an micro controller, two proof of concepts were developed.
- [Arduino Uno Prototype](./MicroHs_Contributions/arduino-uno-prototype.diff)
- [Raspberry Pi Pico Prototype](./MicroHs_Contributions/raspberry-pi-pico.diff)

During the development of this project, issues and pull requests were created for MicroHs:
- [Issue - mhs: error: no location: Not a valid C type: () #70 ](https://github.com/augustss/MicroHs/issues/70)
- [Pull Request - Remove Primitives prefix](https://github.com/augustss/MicroHs/pull/76)
- [Pull request - Implement clamp in Data.Ord](https://github.com/augustss/MicroHs/pull/78)
- [Issue - Segmentation fault (core dumped)](https://github.com/augustss/MicroHs/issues/79)

To keep everything in one place, the diffs and patches are stored in the `MicroHs_Contributions` folder.
