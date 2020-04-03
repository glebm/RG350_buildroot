
OD_CPU_GOVERNOR_SELECTOR_SITE = $(BR2_EXTERNAL)/package/od-cpu-governor-selector
OD_CPU_GOVERNOR_SELECTOR_SITE_METHOD = local

OD_CPU_GOVERNOR_SELECTOR_DEPENDENCIES = dialog

ifeq ($(BR2_PACKAGE_GMENU2X),y)
OD_CPU_GOVERNOR_SELECTOR_DEPENDENCIES += gmenu2x
define OD_CPU_GOVERNOR_SELECTOR_INSTALL_TARGET_GMENU2X
	$(INSTALL) -m 0644 -D $(@D)/gmenu2x $(TARGET_DIR)/usr/share/gmenu2x/sections/settings/70_cpu_governor
	$(INSTALL) -m 0644 -D $(@D)/icon.png $(TARGET_DIR)/usr/share/gmenu2x/skins/Default/icons/od-cpu-governor-selector.png
endef
endif

ifeq ($(BR2_PACKAGE_OD_CPU_GOVERNOR_SELECTOR_SYSTEM_APP),y)
define OD_CPU_GOVERNOR_SELECTOR_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/od-cpu-governor-selector.sh $(TARGET_DIR)/usr/bin/od-cpu-governor-selector
	$(OD_CPU_GOVERNOR_SELECTOR_INSTALL_TARGET_GMENU2X)
endef
else
define OD_CPU_GOVERNOR_SELECTOR_INSTALL_TARGET_CMDS
	mkdir -p $(BINARIES_DIR)/opks
	mksquashfs $(@D)/od-cpu-governor-selector.sh $(@D)/icon.png $(@D)/default.gcw0.desktop \
		$(BINARIES_DIR)/opks/od-cpu-governor-selector.opk \
		-all-root -noappend -no-exports -no-xattrs
endef
endif

$(eval $(generic-package))
