TARGET = iphone:clang:latest:6.0

include theos/makefiles/common.mk

TWEAK_NAME = SpotWolfram
SpotWolfram_FILES = Tweak.xm
SpotWolfram_FRAMEWORKS = UIKit Foundation CoreFoundation

include $(THEOS_MAKE_PATH)/tweak.mk
