#!/bin/sh
# {# jinja-parse #}

WAN_INTF="eth1"
LAN_INTERFACES="eth0 lan0 lan1 lan2 lan3"

get_mac_addr_from_mtk_factory() {
    echo $(/sbin/mtk_factory_rw.sh -r $1 | sed 's/-/:/g')
}

MAC_WAN=$(get_mac_addr_from_mtk_factory wan)
MAC_LAN=$(get_mac_addr_from_mtk_factory lan)

echo "Assigning $WAN_INTF MAC address $MAC_WAN"
ip link set dev $WAN_INTF down
ip link set dev $WAN_INTF address "$MAC_WAN"
ip link set dev $WAN_INTF up

for LAN_INTF in $LAN_INTERFACES
do
    echo "Assigning $LAN_INTF MAC address $MAC_LAN"
    ip link set dev $LAN_INTF down
    ip link set dev $LAN_INTF address "$MAC_LAN"
    ip link set dev $LAN_INTF up
done
