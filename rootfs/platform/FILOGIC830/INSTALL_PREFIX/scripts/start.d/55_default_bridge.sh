#!/bin/sh
# {# jinja-parse #}

# add default internal bridge

# Get the MAC address of an interface
mac_get()
{
    ifconfig "$1" | grep -o -E '([A-F0-9]{2}:){5}[A-F0-9]{2}'
}

MAC_LAN=$(mac_get eth0)
MAC_BRHOME=$MAC_LAN

echo "Adding LAN bridge with MAC address $MAC_BRHOME"
ovs-vsctl add-br {{ CONFIG_TARGET_LAN_BRIDGE_NAME }}
ovs-vsctl set bridge {{ CONFIG_TARGET_LAN_BRIDGE_NAME }} other-config:hwaddr="$MAC_BRHOME"
ip link set dev {{ CONFIG_TARGET_LAN_BRIDGE_NAME }} up
