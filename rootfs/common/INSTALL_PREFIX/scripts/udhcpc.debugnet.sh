#!/bin/sh
[ -z "$1" ] && echo "Error: should be run by udhcpc" && exit 1

log_event()
{
    _event=$1
    shift
    logger -t "udhcpc" "$interface: $_event: $*"
}

setup_interface()
{
    _subnet=${subnet:-255.255.255.0}
    _addr="$ip/$_subnet"

    log_event "$1" "adding/replacing ipv4 addr $_addr"
    ip addr replace dev "$interface" "$_addr" broadcast "${broadcast:-+}"
}

case "$1" in
        deconfig)
            log_event "$1" "flushing all ipv4 addr"
            ip -4 addr flush dev "$interface"
        ;;
        renew)
            setup_interface "$1"
        ;;
        bound)
            setup_interface "$1"
        ;;
esac

exit 0
