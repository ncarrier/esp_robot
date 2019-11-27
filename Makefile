include build_system/utils.mk
include build_system/compiler-defs.mk

#inclusion order is important
include packages/esp8266wifi.mk
include packages/esp8266mdns.mk
include packages/hash.mk
include packages/esp8266webserver.mk
include packages/servo.mk
include packages/websockets.mk
include packages/core.mk

Q ?= @

.DEFAULT_GOAL := all

all: esp_robot summary

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
		--out $@ || echo plop

summary: esp_robot.elf
	$(Q) $(python3) $(tools)sizes.py --elf $^ --path $(tools_bin)

esp_robot.elf:$(archives) esp_robot.cpp.o local.eagle.app.v6.common.ld
	@echo Linking $@
	$(Q) $(CC) \
	-fno-exceptions \
	-Wl,-Map \
	-Wl,esp_robot.cpp.map \
	-g \
	-Os \
	-nostdlib \
	-Wl,--no-check-sections \
	-u app_entry \
	-u _printf_float \
	-u _scanf_float \
	-Wl,-static \
	-L$(sdk)lib \
	-L$(sdk)lib/NONOSDK22x_191024 \
	-L$(sdk)ld \
	-L$(sdk)libc/xtensa-lx106-elf/lib \
	-Teagle.flash.4m2m.ld \
	-Wl,--gc-sections \
	-Wl,-wrap,system_restart_local \
	-Wl,-wrap,spi_flash_read \
	-o $@ \
	-Wl,--start-group \
	$(archives) \
	esp_robot.cpp.o \
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

local.eagle.app.v6.common.ld: $(sdk)ld/eagle.app.v6.common.ld.h
	@echo Generating $@
	$(Q) $(CC) -CC -E -P -DVTABLES_IN_FLASH $^ -o $@

esp_robot_includes := \
	-I$(servo_dir) \
	-I$(esp8266wifi_dir) \
	-I$(esp8266webserver_dir) \
	-I$(esp8266mdns_dir) \
	-I$(websockets_dir)

esp_robot.cpp.o: esp_robot.cpp
	@echo [C++] Compiling $^
	$(Q) $(CXX) $(CPPFLAGS) $(CXXFLAGS) $(esp_robot_includes) $^ -o $@

help:
	echo $(archives)
	echo $(servo_includes)
	echo $(websockets_includes)

clean:
	@rm -rf $(objects)
	@rm -rf $(archives)
	@rm -rf esp_robot.cpp.o
	@rm -rf esp_robot.cpp.map
	@rm -rf esp_robot.elf
	@rm -rf esp_robot
	@rm -rf local.eagle.app.v6.common.ld

.PHONY:all clean help summary
