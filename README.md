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
