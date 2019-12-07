# wifi controlled robot based on a Node MCU

## fetch the code and tools

    pip3 install cpplint
    git clone --recurse-submodules https://github.com/ncarrier/esp_robot
    cd esp_robot
    cd submodules/Arduino/tools/
    ./get.py
    cd -

For cpplint to work, it may be required to add ~/.local/bin to your PATH
environment variable.

## build

    mkdir out
    cd out
    make -f ../Makefile # builds the program, the fs and flashes everything

To only build the program:

    make -f ../Makefile esp_robot

More information on the targets available:

    make -f ../Makefile help

## hacking

Expect nothing to work.

Code style should follow the Google C++ code style. The esp_robot.cpp file will
be checked at compilation. Use the `lint` target to only check the style.
In `tools/` is provided the eclipse settings for the C/C++ formatter.

## license

GPLv3
