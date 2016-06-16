################################################################################
#
# kernel-tools
#
################################################################################

KERNEL_TOOLS_NAME	:= linux-tools
KERNEL_TOOLS_VERSION	:=
KERNEL_TOOLS_TARGET	:= $(BOARD_INTEL_KERNEL_TOOLS)
KERNEL_TOOLS_SOURCE	:= $(KERNEL_SRC)

define KERNEL_TOOLS_MAKE_ONE
	$(Q)for t in $(KERNEL_TOOLS_TARGET); do			\
		$(MAKE1) -C $(KERNEL_SRC)			\
			CROSS_COMPILE="$(TARGET_CROSS)"		\
			DESTDIR="$(TARGET_DIR)"			\
			tools/$${t}_$(1);			\
	done
endef

kernel-tools: PKG = KERNEL_TOOLS
kernel-tools: $(call qstrip,$(BR2_TOOLCHAIN_BUILDROOT_LIBC))
	$(Q)$(call MESSAGE,"Building...")
	$(Q)$(call KERNEL_TOOLS_MAKE_ONE,install)

kernel-tools-clean: PKG = KERNEL_TOOLS
kernel-tools-clean:
	$(Q)$(call MESSAGE,"Cleaning...")
	$(Q)$(call KERNEL_TOOLS_MAKE_ONE,clean)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(BR2_PACKAGE_KERNEL_TOOLS),y)
PACKAGES += kernel-tools
endif
