tools_bin := $(tools)xtensa-lx106-elf/bin
tool_chain := $(tools_bin)/xtensa-lx106-elf-
CXX := $(tool_chain)g++
CC := $(tool_chain)gcc
AR := $(tool_chain)ar

definitions := \
	-D__ets__ \
	-DICACHE_FLASH \
	-U__STRICT_ANSI__ \
	-DNONOSDK22x_191024=1 \
	-DF_CPU=80000000L \
	-DLWIP_OPEN_SRC \
	-DTCP_MSS=536 \
	-DLWIP_FEATURES=1 \
	-DLWIP_IPV6=0 \
	-DARDUINO=10810 \
	-DARDUINO_ESP8266_NODEMCU \
	-DARDUINO_ARCH_ESP8266 \
	"-DARDUINO_BOARD=\"ESP8266_NODEMCU\"" \
	-DLED_BUILTIN=2 \
	-DFLASHMODE_DIO \
	-DESP8266

includes := \
	-I$(tools)sdk/include \
	-I$(tools)sdk/lwip2/include \
	-I$(tools)sdk/libc/xtensa-lx106-elf/include \
	-Isubmodules/Arduino/cores/esp8266 \
	-Isubmodules/Arduino/variants/nodemcu

CPPFLAGS := $(definitions) \
	$(includes)

base_flags := \
	-c \
	-Os \
	-g \
	-mlongcalls \
	-mtext-section-literals \
	-falign-functions=4 \
	-MMD \
	-ffunction-sections \
	-fdata-sections \
	-fno-exceptions

CXXFLAGS := \
	$(base_flags) \
	-std=gnu++11 \
	-fno-rtti

CFLAGS := \
	$(base_flags) \
	-Wpointer-arith \
	-Wno-implicit-function-declaration \
	-std=gnu99 \
	-Wl,-EL \
	-fno-inline-functions \
	-nostdlib \
	-Wmissing-prototypes

ASFLAGS := \
	-c \
	-g \
	-x assembler-with-cpp \
	-MMD \
	-mlongcalls
