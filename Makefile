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

esp_robot: $(archives) esp_robot.o
	echo $@

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

.PHONY:clean help
