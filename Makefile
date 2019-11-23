tools_bin := submodules/Arduino/tools/xtensa-lx106-elf/bin
CXX := $(tools_bin)/xtensa-lx106-elf-g++
AR := $(tools_bin)/xtensa-lx106-elf-ar

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
	-Isubmodules/Arduino/tools/sdk/include \
	-Isubmodules/Arduino/tools/sdk/lwip2/include \
	-Isubmodules/Arduino/tools/sdk/libc/xtensa-lx106-elf/include \
	-Isubmodules/Arduino/cores/esp8266 \
	-Isubmodules/Arduino/variants/nodemcu

CPPFLAGS := $(definitions) \
	$(includes)

CXXFLAGS := \
	-w \
	-Os \
	-g \
	-mlongcalls \
	-mtext-section-literals \
	-fno-rtti \
	-falign-functions=4 \
	-std=gnu++11 \
	-MMD \
	-ffunction-sections \
	-fdata-sections \
	-fno-exceptions

websockets_dir := submodules/arduinoWebSockets/src/
websockets_includes := -I$(websockets_dir) \
	-Isubmodules/Arduino/libraries/ESP8266WiFi/src/ \
	-Isubmodules/Arduino/libraries/Hash/src
	 # TODO should move to wifi and hash
	 
websockets_modules := \
	SocketIOclient \
	WebSockets

websockets_src_files := $(addprefix $(websockets_dir),$(addsuffix .cpp,$(websockets_modules)))
websockets_obj_files := $(addprefix $(websockets_dir),$(addsuffix .o,$(websockets_modules)))

websockets.a: $(websockets_obj_files)
	echo $^
	$(AR) cru $@ $^

$(websockets_obj_files): $(websockets_dir)%.o: $(websockets_dir)%.cpp
	echo here
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(websockets_includes) $^ -c -o $@

help:
	echo $(websockets_obj_files)
	echo $(websockets_dir)
	echo $(websockets_src_files)
	echo $(websockets_obj_files)
	echo $(CFLAGS)
	echo $(websockets_dir)/%.o

clean:
	rm -rf $(websockets_obj_files)
	rm -rf websockets.a

.PHONY:clean



#	-I/home/nicolas/.arduino15/packages/esp8266/hardware/esp8266/2.6.1/libraries/Servo/src \
#	-I/home/nicolas/.arduino15/packages/esp8266/hardware/esp8266/2.6.1/libraries/ESP8266WiFi/src \
#	-I/home/nicolas/.arduino15/packages/esp8266/hardware/esp8266/2.6.1/libraries/ESP8266WebServer/src \
#	-I/home/nicolas/.arduino15/packages/esp8266/hardware/esp8266/2.6.1/libraries/ESP8266mDNS/src \
#	-Isubmodules/arduinoWebSockets/src/ \
#	-I/home/nicolas/.arduino15/packages/esp8266/hardware/esp8266/2.6.1/libraries/Hash/src
#