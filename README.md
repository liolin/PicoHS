# PicoHs
Support files to develop an MicroHs application for the Raspberry Pi Go.


## Build
Initial build:
```sh
cmake -B build
cmake --build build
```

Recompile after changes to `Blinky.hs`:
```sh
cmake --build build
```

## Flash
```sh
cp build/pico-go.uf2
```

## USB
```
minicom -b 115200 -o -D /dev/ttyACM0
```

## Run PicoGo
1. Copy application to the PicoGo
2. Unplug USB Cable
3. Turn the PicoGo on (switch on the bottom side)
