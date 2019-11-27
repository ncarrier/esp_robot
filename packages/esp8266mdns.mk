$(pkgname)_dir := submodules/Arduino/libraries/ESP8266mDNS/src/
$(pkgname)_includes := \
	-I$(root_dir)$(esp8266wifi_dir)
$(pkgname)_cpp:= \
	LEAmDNS_Control \
	ESP8266mDNS \
	ESP8266mDNS_Legacy \
	LEAmDNS \
	LEAmDNS_Helpers \
	LEAmDNS_Structs \
	LEAmDNS_Transfer

$(eval $(package))