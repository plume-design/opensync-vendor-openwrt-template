# Chipset vendor reference boards:
OWRT_TEMPLATE_TARGETS := FILOGIC820-AX3000 FILOGIC830-AX6000 FILOGIC830-AX7800 FILOGIC830-AX8400 FILOGIC880-BE7200 FILOGIC880-BE19000 EN7523EVB1.0
# Open source HW:
OWRT_TEMPLATE_TARGETS += LINKSYS_MR8300 BPI-R3 BPI-R4

OS_TARGETS += $(OWRT_TEMPLATE_TARGETS)

TARGET ?= $(DEFAULT_TARGET)

ifneq ($(filter $(TARGET),$(OWRT_TEMPLATE_TARGETS)),)
PLATFORM := cfg80211
VENDOR := openwrt-template
VENDOR_DIR := vendor/$(VENDOR)

# By default, search through all service-provider directories
# starting with "local"
SERVICE_PROVIDERS ?= local ALL

# Default image deployment profile which must be defined in one of the cloned
# service-provider directories. The "local" profile is found in the "local"
# service provider repository.
export IMAGE_DEPLOYMENT_PROFILE ?= local

KCONFIG_TARGET ?= $(VENDOR_DIR)/kconfig/targets/$(TARGET)
ARCH_MK = $(PLATFORM_DIR)/build/$(PLATFORM).mk
-include $(VENDOR_DIR)/build/$(TARGET).mk

OS_CFLAGS += -I$(STAGING_DIR)/usr/include/protobuf-c \
          -I$(STAGING_DIR)/usr/include/openvswitch
endif

SDK_MKSQUASHFS_CMD = $(STAGING_DIR)/../host/bin/mksquashfs4
SDK_MKSQUASHFS_ARGS = -noappend -root-owned -comp xz
