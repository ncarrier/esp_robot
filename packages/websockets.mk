websockets_dir := submodules/arduinoWebSockets/src/
websockets_includes := \
	-I$(esp8266wifi_dir) \
	-I$(hash_dir) \
	-I$(websockets_dir)
websockets_modules := \
	SocketIOclient \
	WebSockets

$(eval $(package))