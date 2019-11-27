pkgname = $(basename $(notdir $(lastword $(MAKEFILE_LIST))))

define inner-package

$(1)_includes += -I$$($(1)_dir)

$(1)_obj_files := $(addprefix $($(1)_dir),$(addsuffix .cpp.o,$($(1)_cpp))) \
	$(addprefix $($(1)_dir),$(addsuffix .S.o,$($(1)_S))) \
	$(addprefix $($(1)_dir),$(addsuffix .c.o,$($(1)_c)))

$$($(1)_dir)%.cpp.o: $$($(1)_dir)%.cpp
	@echo [C++] Compiling $$^
	$$(Q) $$(CXX) $$(CPPFLAGS) $$(CXXFLAGS) $$($(1)_includes) $$^ -o $$@

$$($(1)_dir)%.c.o: $$($(1)_dir)%.c
	@echo [C] Compiling $$^
	$$(Q) $$(CC) $$(CPPFLAGS) $(CFLAGS) $$($(1)_includes) $$^ -o $$@

$$($(1)_dir)%.S.o: $$($(1)_dir)%.S
	@echo [assembler] Compiling $$^
	$$(Q) $$(CC) $$(CPPFLAGS) $(ASFLAGS) -I$$($(1)_dir) $$^ -o $$@

$(1).a: $$($(1)_obj_files)
	@echo Creating package archive $$@
	$$(Q) $$(AR) cru $$@ $$^

archives := $$(archives) $(1).a
objects := $$(objects) $$($(1)_obj_files)

endef #inner-package

package = $(call inner-package,$(pkgname))

arduino := submodules/Arduino/
tools := $(arduino)tools/
sdk := $(tools)sdk/
libraries := $(arduino)libraries
python3 ?= $(tools)python3/python3
