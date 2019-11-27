$(pkgname)_dir := submodules/Arduino/libraries/ESP8266WiFi/src/
$(pkgname)_cpp := \
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

$(eval $(package))