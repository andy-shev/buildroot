################################################################################
#
# diod
#
################################################################################

DIOD_VERSION = cd323e2f025125858dcd69bd2e415481277b1b4a
DIOD_SITE = $(call github,chaos,diod,$(DIOD_VERSION))

DIOD_LICENSE = GPL-2.0
DIOD_LICENSE_FILES = COPYING

DIOD_CONF_OPTS += --disable-auth --disable-multiuser --disable-config

define DIOD_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef

DIOD_PRE_CONFIGURE_HOOKS += DIOD_RUN_AUTOGEN

$(eval $(autotools-package))
