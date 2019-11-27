$(pkgname)_dir := submodules/arduinoWebSockets/src/
$(pkgname)_includes := \
	-I$(esp8266mdns_dir) \
	-I$(esp8266webserver_dir) \
	-I$(esp8266wifi_dir) \
	-I$(hash_dir) \
	-I$(servo_dir)
$(pkgname)_cpp := \
	SocketIOclient \
	WebSocketsServer \
	WebSockets
$(pkgname)_c := \
	libb64/cdecode \
	libb64/cencode \
	libsha1/libsha1

$(eval $(package))