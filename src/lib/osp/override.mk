###############################################################################
#
# OSP overrides
#
###############################################################################

UNIT_SRC := $(filter-out src/osp_sec_key.c,$(UNIT_SRC))
UNIT_SRC_TOP += $(OVERRIDE_DIR)/src/osp_sec_key.c

UNIT_SRC_TOP += $(if $(CONFIG_OSP_UNIT_OPENWRT_TEMPLATE), $(OVERRIDE_DIR)/src/osp_unit_openwrt_template.c)
