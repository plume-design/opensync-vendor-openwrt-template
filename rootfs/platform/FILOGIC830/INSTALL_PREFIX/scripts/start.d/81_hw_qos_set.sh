#!/bin/sh

# config qdma_txq for hw qos
# qdma_txq assignment:
# [0:5]   : pppq -config in driver
# [6:7]   : reserved
# [8:15]  : dscp for app/mac prioritization
# [16:47] : QoSM -config in osn qos api
# [48:63] : reserved

# HW capability: max ratelimit bw: 1000000 kbps
# Disable ratelimit by default
q_bw=1000000
q_maxrate_percent=0
q_minrate_percent=0
q_sch=1
q_resv=4
q_weight=4
q_maxebl=1
q_minebl=1

q_maxrate=$((q_bw * $q_maxrate_percent))
q_maxrate=$((q_maxrate / 100))

q_minrate=$((q_bw * $q_minrate_percent))
q_minrate=$((q_minrate / 100))

[ "${q_maxrate}" -eq 0 ] && q_maxebl=0
[ "${q_minrate}" -eq 0 ] && q_minebl=0

# queue config for dscp
#  qid   :  dscp class : wmm ac
#  8/11  :  BE/CS3     : BE
#  9/10  :  CS1/CS2    : BK
#  12/13 :  CS4/CS5    : VI
#  14/15 :  CS6/CS7    : VO

for q_id in $(seq 8 15)
do
    if [ "${q_id}" -eq 8 ] || [ "${q_id}" -eq 11 ]; then
        q_weight=4
    elif [ "${q_id}" -eq 9 ] || [ "${q_id}" -eq 10 ]; then
        q_weight=2
    elif [ "${q_id}" -eq 12 ] || [ "${q_id}" -eq 13 ]; then
        q_weight=6
    else
        q_weight=8
    fi

    echo ${q_sch} ${q_minebl} ${q_minrate} ${q_maxebl} ${q_maxrate} ${q_weight} ${q_resv} > /sys/kernel/debug/mtk_ppe/qdma_txq${q_id}
done
