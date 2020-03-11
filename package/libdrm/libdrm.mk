################################################################################
#
# libdrm
#
################################################################################

LIBDRM_VERSION = 2.4.100
LIBDRM_SOURCE = libdrm-$(LIBDRM_VERSION).tar.bz2
LIBDRM_SITE = https://dri.freedesktop.org/libdrm
LIBDRM_LICENSE = MIT
LIBDRM_INSTALL_STAGING = YES

LIBDRM_DEPENDENCIES = \
	libpthread-stubs \
	host-pkgconf

LIBDRM_CONF_OPT = \
	-Dcairo-tests=false \
	-Dmanpages=false

ifeq ($(BR2_PACKAGE_LIBATOMIC_OPS),y)
LIBDRM_DEPENDENCIES += libatomic_ops
ifeq ($(BR2_sparc_v8)$(BR2_sparc_leon3),y)
LIBDRM_CFLAGS = $(TARGET_CFLAGS) -DAO_NO_SPARC_V9
endif
endif

ifeq ($(BR2_PACKAGE_LIBDRM_INTEL),y)
LIBDRM_CONF_OPT += -Dintel=true
LIBDRM_DEPENDENCIES += libpciaccess
else
LIBDRM_CONF_OPT += -Dintel=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_RADEON),y)
LIBDRM_CONF_OPT += -Dradeon=true
else
LIBDRM_CONF_OPT += -Dradeon=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_AMDGPU),y)
LIBDRM_CONF_OPT += -Damdgpu=true
else
LIBDRM_CONF_OPT += -Damdgpu=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_NOUVEAU),y)
LIBDRM_CONF_OPT += -Dnouveau=true
else
LIBDRM_CONF_OPT += -Dnouveau=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_VMWGFX),y)
LIBDRM_CONF_OPT += -Dvmwgfx=true
else
LIBDRM_CONF_OPT += -Dvmwgfx=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_OMAP),y)
LIBDRM_CONF_OPT += -Domap=true
else
LIBDRM_CONF_OPT += -Domap=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_ETNAVIV),y)
LIBDRM_CONF_OPT += -Detnaviv=true
else
LIBDRM_CONF_OPT += -Detnaviv=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_EXYNOS),y)
LIBDRM_CONF_OPT += -Dexynos=true
else
LIBDRM_CONF_OPT += -Dexynos=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_FREEDRENO),y)
LIBDRM_CONF_OPT += -Dfreedreno=true
else
LIBDRM_CONF_OPT += -Dfreedreno=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_TEGRA),y)
LIBDRM_CONF_OPT += -Dtegra=true
else
LIBDRM_CONF_OPT += -Dtegra=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_VC4),y)
LIBDRM_CONF_OPT += -Dvc4=true
else
LIBDRM_CONF_OPT += -Dvc4=false
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBDRM_CONF_OPT += -Dudev=true
LIBDRM_DEPENDENCIES += udev
else
LIBDRM_CONF_OPT += -Dudev=false
endif

ifeq ($(BR2_PACKAGE_VALGRIND),y)
LIBDRM_CONF_OPT += -Dvalgrind=true
LIBDRM_DEPENDENCIES += valgrind
else
LIBDRM_CONF_OPT += -Dvalgrind=false
endif

ifeq ($(BR2_PACKAGE_LIBDRM_INSTALL_TESTS),y)
LIBDRM_CONF_OPT += -Dinstall-test-programs=true
ifeq ($(BR2_PACKAGE_CUNIT),y)
LIBDRM_DEPENDENCIES += cunit
endif
endif

$(eval $(meson-package))
