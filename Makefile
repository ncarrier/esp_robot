VPATH := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
root_dir := $(VPATH)

include $(root_dir)build_system/utils.mk
include $(root_dir)build_system/compiler-defs.mk

#inclusion order is important
include $(root_dir)packages/esp8266wifi.mk
include $(root_dir)packages/esp8266mdns.mk
include $(root_dir)packages/hash.mk
include $(root_dir)packages/esp8266webserver.mk
include $(root_dir)packages/servo.mk
include $(root_dir)packages/websockets.mk
include $(root_dir)packages/core.mk

Q ?= @
PORT ?= /dev/ttyUSB0

.DEFAULT_GOAL := all

all: summary flash

flash: flash_esp_robot flash_spiffs

# prevents parallel execution of the two flash targets
flash_esp_robot: | flash_spiffs
flash_esp_robot: esp_robot
	@echo "Flashing the program"
	$(Q) $(python3) $(tools)upload.py --chip esp8266 --port $(PORT) \
		--baud 115200 --before default_reset --after hard_reset $^

flash_spiffs: spiffs
	@echo "Flashing the file system"
	$(Q) PYTHONPATH=$(tools)pyserial/ $(tools)/python3/python3 \
		$(tools)/esptool/esptool.py write_flash 0x200000 $^

resources_dir := $(root_dir)resources/
resources := $(wildcard $(resources_dir)*)
spiffs:	$(resources)
	$(tools)mkspiffs/mkspiffs -c $(resources_dir) $@

esp_robot: esp_robot.elf
	@echo Generating final payload $@
	$(Q) $(python3) \
		$(tools)elf2bin.py \
		--eboot $(arduino)bootloaders/eboot/eboot.elf \
		--app $^ \
		--flash_mode dio \
		--flash_freq 40 \
		--flash_size 4M \
		--path $(tools_bin) \
		--out $@

summary: esp_robot.elf
	$(Q) $(python3) $(tools)sizes.py --elf $^ --path $(tools_bin)

esp_robot_link_locations := \
	lib \
	lib/NONOSDK22x_191024 \
	ld \
	libc/xtensa-lx106-elf/lib

esp_robot_libraries := \
	hal \
	phy \
	pp \
	net80211 \
	lwip2-536-feat \
	wpa \
	crypto \
	main \
	wps \
	bearssl \
	axtls \
	espnow \
	smartconfig \
	airkiss \
	wpa2 \
	stdc++ \
	m \
	c \
	gcc \

esp_robot.elf:$(archives) esp_robot.cpp.o local.eagle.app.v6.common.ld
	@echo Linking $@
	$(Q) $(CC) \
	-Wl,-Map \
	-Wl,esp_robot.cpp.map \
	$(ultra_base_flags) \
	-Wl,--no-check-sections \
	-u app_entry \
	-u _printf_float \
	-u _scanf_float \
	-Wl,-static \
	$(foreach l,$(esp_robot_link_locations),-L$(sdk)$(l)) \
	-Teagle.flash.4m2m.ld \
	-Wl,--gc-sections \
	-Wl,-wrap,system_restart_local \
	-Wl,-wrap,spi_flash_read \
	-o $@ \
	-Wl,--start-group \
	$(archives) \
	esp_robot.cpp.o \
	$(foreach l,$(esp_robot_libraries),-l$(l)) \
	-Wl,--end-group \
	-L.

local.eagle.app.v6.common.ld: $(sdk)ld/eagle.app.v6.common.ld.h
	@echo Generating $@
	$(Q) $(CC) -CC -E -P -DVTABLES_IN_FLASH $^ -o $@

esp_robot_includes := \
	-I$(root_dir)$(servo_dir) \
	-I$(root_dir)$(esp8266wifi_dir) \
	-I$(root_dir)$(esp8266webserver_dir) \
	-I$(root_dir)$(esp8266mdns_dir) \
	-I$(root_dir)$(websockets_dir)

esp_robot.cpp.o: esp_robot.cpp
	@echo [C++] Compiling $^
	$(Q) $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(esp_robot_includes) $^ -o $@

help:
	@echo $(archives)
	@echo $(servo_includes)
	@echo $(websockets_includes)
	@echo $(foreach l,$(esp_robot_link_locations),-L$(sdk)$(l))
	@echo $(foreach l,$(esp_robot_libraries),-l$(l))

clean:
	@rm -rf $(objects)
	@rm -rf $(archives)
	@rm -rf esp_robot.cpp.o
	@rm -rf esp_robot.cpp.map
	@rm -rf esp_robot.elf
	@rm -rf esp_robot
	@rm -rf local.eagle.app.v6.common.ld
	@rm -rf spiffs

.PHONY:all clean flash flash_esp_robot flash_spiffs help summary
