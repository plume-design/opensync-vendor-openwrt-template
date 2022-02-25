#!/bin/sh
# {# jinja-parse #}
INSTALL_PREFIX={{INSTALL_PREFIX}}

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
MAC_ETH1=$(mac_get {{CONFIG_TARGET_ETH1_NAME}})
# Set the local bit on eth1
MAC_ETH0=$(mac_set_local_bit ${MAC_ETH1})

echo "Adding br-wan with MAC address $MAC_ETH1"
ovs-vsctl add-br br-wan
ovs-vsctl set bridge br-wan other-config:hwaddr="$MAC_ETH1"
ovs-vsctl set int br-wan mtu_request=1500

echo "Adding br-lan with MAC address $MAC_ETH0"
ovs-vsctl add-br br-lan
ovs-vsctl set bridge br-lan other-config:hwaddr="$MAC_ETH0"
ovs-vsctl add-port br-lan {{CONFIG_TARGET_ETH0_NAME}}

echo "Enabling LAN interface eth1"
ifconfig {{CONFIG_TARGET_ETH1_NAME}} up

# Update Open_vSwitch table: Must be done here instead of pre-populated
# because row doesn't exist until openvswitch is started
ovsdb-client transact '
["Open_vSwitch", {
    "op": "insert",
    "table": "SSL",
    "row": {
        "ca_cert": "/var/run/openvswitch/certs/ca.pem",
        "certificate": "/var/run/openvswitch/certs/client.pem",
        "private_key": "/var/run/openvswitch/certs/client_dec.key"
    },
    "uuid-name": "ssl_id"
}, {
    "op": "update",
    "table": "Open_vSwitch",
    "where": [],
    "row": {
        "ssl": ["set", [["named-uuid", "ssl_id"]]]
    }
}]'

# Change interface stats update interval to 1 hour
ovsdb-client transact '
["Open_vSwitch", {
    "op": "update",
    "table": "Open_vSwitch",
    "where": [],
    "row": {
        "other_config": ["map", [["stats-update-interval", "3600000"] ]]
    }
}]'
