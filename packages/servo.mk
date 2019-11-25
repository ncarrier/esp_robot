servo_dir := submodules/Arduino/libraries/Servo/src/
servo_includes := \
	-I$(servo_dir)
servo_modules := \
	Servo

$(eval $(package))
