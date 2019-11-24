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

esp_robot: websockets.a servo.a esp8266wifi.a esp_robot.o
	echo $@

servo_dir := submodules/Arduino/libraries/Servo/src/
servo_includes := \
	-I$(servo_dir)
servo_modules := \
	Servo
servo_obj_files := $(addprefix $(servo_dir),$(addsuffix .o,$(servo_modules)))

servo.a: $(servo_obj_files)
	$(AR) cru $@ $^

$(servo_obj_files): $(servo_dir)%.o: $(servo_dir)%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(servo_includes) $^ -c -o $@

esp8266wifi_dir := submodules/Arduino/libraries/ESP8266WiFi/src/
esp8266wifi_includes := \
	-I$(esp8266wifi_dir)
esp8266wifi_modules := \
	ESP8266WiFiAP \
	ESP8266WiFi \
	BearSSLHelpers \
	CertStoreBearSSL \
	ESP8266WiFiGeneric \
	ESP8266WiFiMulti \
	ESP8266WiFiSTA-WPS \
	ESP8266WiFiSTA \
	ESP8266WiFiScan \
	WiFiClient \
	WiFiClientSecureAxTLS \
	WiFiClientSecureBearSSL \
	WiFiServer \
	WiFiServerSecureAxTLS \
	WiFiServerSecureBearSSL \
	WiFiUdp
esp8266wifi_obj_files := $(addprefix $(esp8266wifi_dir),$(addsuffix .o,$(esp8266wifi_modules)))
$(esp8266wifi_obj_files): $(esp8266wifi_dir)%.o: $(esp8266wifi_dir)%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(esp8266wifi_includes) $^ -c -o $@
esp8266wifi.a: $(esp8266wifi_obj_files)
	$(AR) cru $@ $^

esp8266webserver_dir := submodules/Arduino/libraries/ESP8266WebServer/src/
esp8266mdns_dir := submodules/Arduino/libraries/ESP8266mDNS/src/
hash_dir := submodules/Arduino/libraries/Hash/src

websockets_dir := submodules/arduinoWebSockets/src/
websockets_includes := \
	-I$(esp8266wifi_dir) \
	-I$(hash_dir) \
	-I$(websockets_dir)
websockets_modules := \
	SocketIOclient \
	WebSockets
websockets_obj_files := $(addprefix $(websockets_dir),$(addsuffix .o,$(websockets_modules)))

websockets.a: $(websockets_obj_files)
	$(AR) cru $@ $^

$(websockets_obj_files): $(websockets_dir)%.o: $(websockets_dir)%.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(websockets_includes) $^ -c -o $@

esp_robot_includes := \
	-I$(servo_dir) \
	-I$(esp8266wifi_dir) \
	-I$(esp8266webserver_dir) \
	-I$(esp8266mdns_dir) \
	-I$(websockets_dir)

esp_robot.o: esp_robot.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(esp_robot_includes) $^ -c -o $@

help:
	echo $(esp8266wifi_obj_files)
	echo $(esp8266wifi_includes)
	echo $(websockets_obj_files)
	echo $(websockets_dir)/%.o

clean:
	rm -rf $(servo_obj_files)
	rm -rf $(websockets_obj_files)
	rm -rf $(esp8266wifi_obj_files)
	rm -rf servo.a
	rm -rf websockets.a
	rm -rf esp8266wifi.a
	rm -rf esp_robot.o

.PHONY:clean
