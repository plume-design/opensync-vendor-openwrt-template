ROOTFS_PLATFORM_COMPONENTS += platform/FILOGIC820
OVS_PACKAGE_VER := $(shell sed -n '/^ovs_version/{s/^.*=//p;q}' $(TOPDIR)/feeds/packages/net/openvswitch/openvswitch.mk)
