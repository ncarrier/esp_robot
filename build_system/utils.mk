pkgname = $(basename $(notdir $(lastword $(MAKEFILE_LIST))))

define inner-package

$(1)_obj_files := $(addprefix $($(1)_dir),$(addsuffix .o,$($(1)_modules)))
$$($(1)_obj_files): $$($(1)_dir)%.o: $$($(1)_dir)%.cpp
	@echo Compiling $$^
	$$(Q) $$(CXX) $$(CPPFLAGS) $$(CXXFLAGS) $$($(1)_includes) -I$$($(1)_dir) $$^ -c -o $$@
$(1).a: $$($(1)_obj_files)
	@echo Creating package archive $$@
	$$(Q) $$(AR) cru $$@ $$^

archives := $$(archives) $(1).a
objects := $$(objects) $$($(1)_obj_files)

endef #inner-package

package = $(call inner-package,$(pkgname))
