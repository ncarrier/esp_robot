include build_system/compiler-defs.mk
include build_system/utils.mk

#inclusion order is important
include packages/esp8266wifi.mk
include packages/esp8266mdns.mk
include packages/hash.mk
include packages/esp8266webserver.mk
include packages/servo.mk
include packages/websockets.mk
include packages/core.mk

tools_bin := submodules/Arduino/tools/xtensa-lx106-elf/bin
tool_chain := $(tools_bin)/xtensa-lx106-elf-
CXX := $(tool_chain)g++
CC := $(tool_chain)gcc
AR := $(tool_chain)ar
Q ?= @

.DEFAULT_GOAL := esp_robot

# TODO --path argument seems incorrect
esp_robot: esp_robot.elf
	submodules/Arduino/tools/python3/3.7.2-post1/python3 \
	submodules/Arduino/hardware/esp8266/2.6.1/tools/elf2bin.py \
	--ebootsubmodules/Arduino/hardware/esp8266/2.6.1/bootloaders/eboot/eboot.elf \
	--app $^ \
	--flash_mode dio \
	--flash_freq 40 \
	--flash_size 4M \
	--path submodules/Arduino/tools/xtensa-lx106-elf-gcc/2.5.0-4-b40a506/bin \
	--out $@

esp_robot.elf:$(archives) esp_robot.o local.eagle.app.v6.common.ld
	$(CC) \
	-fno-exceptions \
	-Wl,-Map \
	-Wl,esp_robot.cpp.map \
	-g \
	-w \
	-Os \
	-nostdlib \
	-Wl,--no-check-sections \
	-u app_entry \
	-u _printf_float \
	-u _scanf_float \
	-Wl,-static \
	-Lsubmodules/Arduino/tools/sdk/lib \
	-Lsubmodules/Arduino/tools/sdk/lib/NONOSDK22x_191024 \
	-Lsubmodules/Arduino/tools/sdk/ld \
	-Lsubmodules/Arduino/tools/sdk/libc/xtensa-lx106-elf/lib \
	-Teagle.flash.4m2m.ld \
	-Wl,--gc-sections \
	-Wl,-wrap,system_restart_local \
	-Wl,-wrap,spi_flash_read \
	-o $@ \
	-Wl,--start-group \
	$(archives) \
	esp_robot.o \
	-lhal \
	-lphy \
	-lpp \
	-lnet80211 \
	-llwip2-536-feat \
	-lwpa \
	-lcrypto \
	-lmain \
	-lwps \
	-lbearssl \
	-laxtls \
	-lespnow \
	-lsmartconfig \
	-lairkiss \
	-lwpa2 \
	-lstdc++ \
	-lm \
	-lc \
	-lgcc \
	-Wl,--end-group \
	-L.

local.eagle.app.v6.common.ld: submodules/Arduino/tools/sdk/ld/eagle.app.v6.common.ld.h
	$(CC) -CC -E -P -DVTABLES_IN_FLASH $^ -o $@

esp_robot_includes := \
	-I$(servo_dir) \
	-I$(esp8266wifi_dir) \
	-I$(esp8266webserver_dir) \
	-I$(esp8266mdns_dir) \
	-I$(websockets_dir)

esp_robot.o: esp_robot.cpp
	@echo Compiling $^
	$(Q) $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(esp_robot_includes) $^ -c -o $@

help:
	echo $(esp8266wifi_includes)
	echo $(servo_includes)
	echo $(websockets_includes)

clean:
	@rm -rf $(objects)
	@rm -rf $(archives)
	@rm -rf esp_robot.o
	@rm -rf local.eagle.app.v6.common.ld

.PHONY:clean help
