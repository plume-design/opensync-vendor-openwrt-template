##############################################################################
#
# TARGET specific layer library
#
##############################################################################

UNIT_CFLAGS := $(filter-out -DTARGET_H=%,$(UNIT_CFLAGS))
UNIT_CFLAGS += -DTARGET_H=\"target_openwrt_template.h\"
UNIT_CFLAGS += -I$(OVERRIDE_DIR)/inc

UNIT_EXPORT_CFLAGS := $(UNIT_CFLAGS)

