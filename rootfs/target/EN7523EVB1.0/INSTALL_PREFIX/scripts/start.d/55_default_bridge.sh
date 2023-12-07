#!/bin/sh
# {# jinja-parse #}
INSTALL_PREFIX={{INSTALL_PREFIX}}

WAN_INTF="eth0.1"
LAN_INTERFACES="eth0.2 eth0.3 eth0.4"

# Add offset to a MAC address
mac_set_local_bit()
{
    local MAC="$1"

    # ${MAC%%:*} - first digit in MAC address
    # ${MAC#*:} - MAC without first digit
    printf "%02X:%s" $(( 0x${MAC%%:*} | 0x2 )) "${MAC#*:}"
}

# Get the MAC address of an interface
mac_get()
{
    ifconfig "$1" | grep -o -E '([A-F0-9]{2}:){5}[A-F0-9]{2}'
}

##
# Configure bridges
#
MAC_LAN=$(mac_get {{CONFIG_TARGET_ETH1_NAME}})
# Set the local bit on lan mac
MAC_WAN=$(mac_set_local_bit ${MAC_LAN})

MAC_BRHOME=$MAC_LAN

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

echo "Adding LAN bridge with MAC address $MAC_BRHOME"
ovs-vsctl add-br {{ CONFIG_TARGET_LAN_BRIDGE_NAME }}
ovs-vsctl set bridge {{ CONFIG_TARGET_LAN_BRIDGE_NAME }} other-config:hwaddr="$MAC_BRHOME"
ip link set dev {{ CONFIG_TARGET_LAN_BRIDGE_NAME }} up

ifconfig eth0 up

