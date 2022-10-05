################################################################################
#
# hid-tools
#
################################################################################

HID_TOOLS_VERSION	:= 0.7
HID_TOOLS_SOURCE	:= hid-tools-$(HID_TOOLS_VERSION).tar.gz
HID_TOOLS_SITE		:= https://gitlab.freedesktop.org/libevdev/hid-tools/-/archive/$(HID_TOOLS_VERSION)
HID_TOOLS_DEPENDENCIES	:= python-parse python-pyudev python-libevdev
HID_TOOLS_LICENSE	:= GPLv2
HID_TOOLS_LICENSE_FILES	:= COPYING
HID_TOOLS_SETUP_TYPE	:= setuptools

$(eval $(python-package))
