################################################################################
#
# hid-replay
#
################################################################################

# https://github.com/bentiss/hid-replay/issues/8
HID_REPLAY_VERSION = 6d83e4883763b55ac809e3ad6c08926e8d1aea72
HID_REPLAY_SITE = https://github.com/bentiss/hid-replay.git
HID_REPLAY_SITE_METHOD = git
HID_REPLAY_AUTORECONF = YES

$(eval $(autotools-package))
