esp8266webserver_dir := submodules/Arduino/libraries/ESP8266WebServer/src/
esp8266webserver_includes := \
	-I$(esp8266webserver_dir)
esp8266webserver_modules := \
	detail/mimetable

$(eval $(package))
