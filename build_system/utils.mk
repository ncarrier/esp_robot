pkgname = $(basename $(notdir $(lastword $(MAKEFILE_LIST))))

define inner-package

$(1)_includes += -I$(root_dir)$$($(1)_dir)

$(1)_obj_files := $(addprefix $($(1)_dir),$(addsuffix .cpp.o,$($(1)_cpp))) \
	$(addprefix $($(1)_dir),$(addsuffix .S.o,$($(1)_S))) \
	$(addprefix $($(1)_dir),$(addsuffix .c.o,$($(1)_c)))

$$($(1)_dir)%.cpp.o: $$($(1)_dir)%.cpp
	@echo [C++] Compiling $$^
	@mkdir -p `dirname $$@`
	$$(Q) $$(CXX) $$(CPPFLAGS) $$(CXXFLAGS) $$($(1)_includes) $$^ -o $$@

$$($(1)_dir)%.cpp.d: $$($(1)_dir)%.cpp
	@mkdir -p `dirname $$@`
	$$(Q) set -e; rm -f $$@; \
		$$(CXX) -M $$(CXXFLAGS) $$(CPPFLAGS) $$($(1)_includes) $$< > $$@.$$$$$$$$; \
		sed 's,\($*\)\.o[ :]*,\1.o $$@ : ,g' < $$@.$$$$$$$$ > $$@; \
		rm -f $$@.$$$$$$$$

$$($(1)_dir)%.c.o: $$($(1)_dir)%.c
	@echo [C] Compiling $$^
	@mkdir -p `dirname $$@`
	$$(Q) $$(CC) $$(CPPFLAGS) $(CFLAGS) $$($(1)_includes) $$^ -o $$@

$$($(1)_dir)%.c.d: $$($(1)_dir)%.c
	@mkdir -p `dirname $$@`
	$$(Q) set -e; rm -f $$@; \
		$$(CC) -M $$(CFLAGS) $$(CPPFLAGS) $$($(1)_includes) $$< > $$@.$$$$$$$$; \
		sed 's,\($*\)\.o[ :]*,\1.o $$@ : ,g' < $$@.$$$$$$$$ > $$@; \
		rm -f $$@.$$$$$$$$

$$($(1)_dir)%.S.o: $$($(1)_dir)%.S
	@echo [assembler] Compiling $$^
	@mkdir -p `dirname $$@`
	$$(Q) $$(CC) $$(ASFLAGS) -I$$($(1)_dir) $$^ -o $$@

$$($(1)_dir)%.S.d: $$($(1)_dir)%.S
	@mkdir -p `dirname $$@`
	$$(Q) set -e; rm -f $$@; \
		$$(CC) $$(ASFLAGS) -I$(root_dir)$$($(1)_dir) -M $$< > $$@.$$$$$$$$; \
		sed 's,\($*\)\.o[ :]*,\1.o $$@ : ,g' < $$@.$$$$$$$$ > $$@; \
		rm -f $$@.$$$$$$$$

$(1).a: $$($(1)_obj_files)
	@echo Creating package archive $$@
	@mkdir -p `dirname $$@`
	$$(Q) $$(AR) cru $$@ $$^

archives := $$(archives) $(1).a
objects := $$(objects) $$($(1)_obj_files)

endef #inner-package

package = $(call inner-package,$(pkgname))

arduino := $(root_dir)submodules/Arduino/
tools := $(arduino)tools/
sdk := $(tools)sdk/
libraries := $(arduino)libraries/
python3 ?= $(tools)python3/python3
