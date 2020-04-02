################################################################################
#
# barony
#
################################################################################

BARONY_VERSION = ebe2baf8d
BARONY_SITE = $(call github,TurningWheel,Barony,$(BARONY_VERSION))

BARONY_DEPENDENCIES += sdl2 sdl2_net sdl2_image sdl2_ttf tremor libpng physfs

BARONY_CONF_OPTS += \
	-DFMOD_ENABLED=OFF -DOPENAL_ENABLED=ON -DTREMOR_ENABLED=ON \
	-DCMAKE_INSTALL_PREFIX=/

BARONY_INSTALL_TARGET_OPTS = DESTDIR=./opk install

# define BARONY_PACK_DATA
# 	cd $(@D) && ./packdata.sh
# endef
# BARONY_PRE_BUILD_HOOKS += BARONY_PACK_DATA

define BARONY_CLEAN_OPK_DIR
	rm -rf $(@D)/opk/
endef
BARONY_PRE_INSTALL_TARGET_HOOKS += BARONY_CLEAN_OPK_DIR

define BARONY_PACKAGE_OPK
	cp $(BR2_EXTERNAL)/package/barony/default.gcw0.desktop \
	  $(BR2_EXTERNAL)/package/barony/readme.gcw0.txt \
	  $(BR2_EXTERNAL)/package/barony/barony32.png \
	  $(@D)/opk/
	mkdir -p $(BINARIES_DIR)/opks
	rm -f $(BINARIES_DIR)/opks/barony.opk
	cd $(@D)/opk && mksquashfs * $(BINARIES_DIR)/opks/barony.opk -noappend -no-exports -no-xattrs
endef
BARONY_POST_INSTALL_TARGET_HOOKS += BARONY_PACKAGE_OPK

$(eval $(cmake-package))
