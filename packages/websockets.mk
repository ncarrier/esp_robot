$(pkgname)_dir := submodules/arduinoWebSockets/src/
$(pkgname)_includes := \
	-I$(root_dir)$(esp8266mdns_dir) \
	-I$(root_dir)$(esp8266webserver_dir) \
	-I$(root_dir)$(esp8266wifi_dir) \
	-I$(root_dir)$(hash_dir) \
	-I$(root_dir)$(servo_dir)
$(pkgname)_cpp := \
	SocketIOclient \
	WebSocketsServer \
	WebSockets
$(pkgname)_c := \
	libb64/cdecode \
	libb64/cencode \
	libsha1/libsha1

$(eval $(package))