cat <<OVS
[
    "Open_vSwitch",
$(test -n "$(eval echo $CONFIG_TARGET_LAN_BRIDGE_NAME)" && \
  test -n "$(eval echo $CONFIG_OVSDB_BOOTSTRAP)" && \
  cat <<INET
    {
        "op":"update",
        "table":"Wifi_Inet_Config",
        "where":[["if_name","==","$(eval echo $CONFIG_TARGET_LAN_BRIDGE_NAME)"]],
        "row": {
            "if_name": "$(eval echo $CONFIG_TARGET_LAN_BRIDGE_NAME)",
            "ip_assign_scheme": "static",
            "inet_addr": "192.168.1.1",
            "netmask": "255.255.255.0",
            "network": true
        }
    },
INET
)
    { "op": "comment", "comment": "" }
]
OVS
