# wifi controlled robot based on a Node MCU

## fetch the code and tools

    git clone --recurse-submodules https://github.com/ncarrier/esp_robot
    cd submodules/Arduino/tools/
    ./get.py

## build

    mkdir out
    cd out
    make -f ../Makefile # builds the program, the fs and flashes everything

To only build the program:

    make -f ../Makefile esp_robot

More information on the targets available:

    make -f ../Makefile help
