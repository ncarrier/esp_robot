websockets_dir := submodules/arduinoWebSockets/src/
websockets_includes := \
	-I$(esp8266mdns_dir) \
	-I$(esp8266webserver_dir) \
	-I$(esp8266wifi_dir) \
	-I$(hash_dir) \
	-I$(servo_dir)
websockets_modules := \
	SocketIOclient \
	WebSocketsServer \
	WebSockets
websockets_c_sources := \
	libb64/cdecode \
	libb64/cencode \
	libsha1/libsha1

$(eval $(package))