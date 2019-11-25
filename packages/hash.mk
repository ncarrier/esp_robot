hash_dir := submodules/Arduino/libraries/Hash/src/
hash_includes := \
	-I$(hash_dir)
hash_modules := \
	Hash

$(eval $(package))
