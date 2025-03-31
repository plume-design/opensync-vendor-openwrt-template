#include "schema_consts.h"
#include "osp_temp.h"
#include "osp_temp_platform.h"
#include "log.h"
#include "const.h"

#define RADIO_TYPE_STR_2G SCHEMA_CONSTS_RADIO_TYPE_STR_2G
#define RADIO_TYPE_STR_5G SCHEMA_CONSTS_RADIO_TYPE_STR_5G
#define RADIO_TYPE_STR_6G SCHEMA_CONSTS_RADIO_TYPE_STR_6G

static const struct temp_src osp_temp_srcs[] = {
    {"ra0", RADIO_TYPE_STR_2G, osp_temp_get_temperature_mwctl},
    {"rai0", RADIO_TYPE_STR_5G, osp_temp_get_temperature_mwctl},
    {"rax0", RADIO_TYPE_STR_6G, osp_temp_get_temperature_mwctl},
};

const struct temp_src *osp_temp_get_srcs(void)
{
    return osp_temp_srcs;
}

int osp_temp_get_srcs_cnt(void)
{
    return ARRAY_SIZE(osp_temp_srcs);
}
