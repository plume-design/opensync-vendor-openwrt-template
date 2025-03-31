#!/bin/sh

increment_mac() {
    mac=$1
    offset=$2
    if [ $mac != "ff:ff:ff:ff:ff:ff" ]; then
        # Split the MAC address into parts
        mac_prefix=$(echo "$mac" | cut -d ':' -f 1-3)
        mac_parts=$(echo "$mac" | tr ':' ' ')

        # Initialize carry variable
        carry=0

        # Iterate through the last 3 parts of the MAC address
        i=6
        while [ $i -gt 3 ]; do
            # Extract the current part and increment
            part=$(echo "$mac_parts" | cut -d' ' -f$i)
            # Convert to decimal
            decimal_value=$(printf "%d" "0x$part")

            if [ $i -eq 6 ]; then
               decimal_value=$((decimal_value + offset))
            fi
            # Do decimal operate
            decimal_value=$(( (decimal_value + carry) % 256 ))

            # If the part became 0, carry over to the next part
            if [ "$decimal_value" -eq 0 ]; then
                carry=1
                hex_value="00"
            else
                carry=0
                hex_value=$(printf "%02x" "$decimal_value")
            fi

            if [ $i -eq 6 ]; then
                idx6_hex=$hex_value
            elif [ $i -eq 5 ]; then
                idx5_hex=$hex_value
            else
                idx4_hex=$hex_value
            fi

            # Move to the previous part
            i=$((i - 1))
        done

        # Reconstruct the MAC address
        new_mac="$mac_prefix:$idx4_hex:$idx5_hex:$idx6_hex"
        echo "$new_mac"
    else
        echo "ETH_MAC $ETH_MAC is invalid"
    fi
}


WIFI_PHY_INTERFACE="phy0 phy1"
ETH_MAC=$(cat /sys/class/net/eth0/address)

i=1
for WIFI_PHY_IFTF in $WIFI_PHY_INTERFACE
do
    MAC_WIFI_TEMP=$(increment_mac $ETH_MAC $i)
    echo $MAC_WIFI_TEMP > "/sys/class/ieee80211/$WIFI_PHY_IFTF/macaddress"
    i=$((i + 1))
done



