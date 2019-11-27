esp8266mdns_dir := submodules/Arduino/libraries/ESP8266mDNS/src/
esp8266mdns_includes := \
	-I$(esp8266wifi_dir)
esp8266mdns_cpp:= \
	LEAmDNS_Control \
	ESP8266mDNS \
	ESP8266mDNS_Legacy \
	LEAmDNS \
	LEAmDNS_Helpers \
	LEAmDNS_Structs \
	LEAmDNS_Transfer

$(eval $(package))