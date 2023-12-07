#!/bin/sh
# {# jinja-parse #}

# add default internal bridge
{%- if CONFIG_TARGET_USE_WAN_BRIDGE %}
# Add offset to a MAC address
mac_set_local_bit()
{
    local MAC="$1"

    # ${MAC%%:*} - first digit in MAC address
    # ${MAC#*:} - MAC without first digit
    printf "%02X:%s" $(( 0x${MAC%%:*} | 0x2 )) "${MAC#*:}"
}
{%- endif %}

# Get the MAC address of an interface
mac_get()
{
    ifconfig "$1" | grep -o -E '([A-F0-9]{2}:){5}[A-F0-9]{2}'
}

MAC_ETH1=$(mac_get eth1)
{%- if CONFIG_TARGET_USE_WAN_BRIDGE %}
# Set the local bit on eth0
MAC_ETH0=$(mac_set_local_bit ${MAC_ETH1})
{%- else %}
MAC_ETH0=$MAC_ETH1
{%- endif %}

{%- if CONFIG_TARGET_USE_WAN_BRIDGE %}
echo "Adding WAN bridge with MAC address $MAC_ETH1"
ovs-vsctl add-br {{ CONFIG_TARGET_WAN_BRIDGE_NAME }}
ovs-vsctl set bridge {{ CONFIG_TARGET_WAN_BRIDGE_NAME }} other-config:hwaddr="$MAC_ETH1"
ovs-vsctl set int {{ CONFIG_TARGET_WAN_BRIDGE_NAME }} mtu_request=1500
ip link set dev {{ CONFIG_TARGET_WAN_BRIDGE_NAME }} up
{%- endif %}

echo "Adding LAN bridge with MAC address $MAC_ETH0"
ovs-vsctl add-br {{ CONFIG_TARGET_LAN_BRIDGE_NAME }}
ovs-vsctl set bridge {{ CONFIG_TARGET_LAN_BRIDGE_NAME }} other-config:hwaddr="$MAC_ETH0"
ovs-vsctl add-port {{ CONFIG_TARGET_LAN_BRIDGE_NAME }} eth0
ip link set dev {{ CONFIG_TARGET_LAN_BRIDGE_NAME }} up
