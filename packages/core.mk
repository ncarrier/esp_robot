core_dir := submodules/Arduino/cores/esp8266/
core_cpp := \
	Esp-frag \
	Esp-version \
	FS \
	Esp \
	FSnoop \
	FunctionalInterrupt \
	HardwareSerial \
	IPAddress \
	MD5Builder \
	Print \
	Schedule \
	StackThunk \
	Stream \
	StreamString \
	Tone \
	Updater \
	WMath \
	WString \
	abi \
	base64 \
	cbuf \
	cont_util \
	core_esp8266_app_entry_noextra4k \
	core_esp8266_eboot_command \
	core_esp8266_features \
	core_esp8266_flash_utils \
	core_esp8266_i2s \
	core_esp8266_main \
	core_esp8266_noniso \
	core_esp8266_phy \
	core_esp8266_postmortem \
	core_esp8266_si2c \
	core_esp8266_sigma_delta \
	core_esp8266_spi_utils \
	core_esp8266_timer \
	core_esp8266_waveform \
	core_esp8266_wiring \
	core_esp8266_wiring_analog \
	core_esp8266_wiring_digital \
	core_esp8266_wiring_pulse \
	core_esp8266_wiring_pwm \
	core_esp8266_wiring_shift \
	crc32 \
	debug \
	flash_hal \
	gdb_hooks \
	heap \
	libc_replacements \
	sntp-lwip2 \
	spiffs_api \
	sqrt32 \
	time \
	uart \
	libb64/cdecode \
	libb64/cencode \
	spiffs/spiffs_cache \
	spiffs/spiffs_check \
	spiffs/spiffs_gc \
	spiffs/spiffs_hydrogen \
	spiffs/spiffs_nucleus \
	umm_malloc/umm_malloc
core_S := \
	cont
core_c := \
	umm_malloc/umm_info \
	umm_malloc/umm_poison \
	umm_malloc/umm_local \
	umm_malloc/umm_integrity

$(eval $(package))
