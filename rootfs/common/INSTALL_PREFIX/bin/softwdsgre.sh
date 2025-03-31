#!/bin/sh -xe
# {# jinja-parse #}
INSTALL_PREFIX={{INSTALL_PREFIX}}

timeout_kill=$(timeout -t 0 true && echo timeout -s KILL -t || echo timeout -s KILL)

ifname=$1
parent=$2
local_ip=$3
remote_ip=$4
remote_mac=$5
ovsh=${INSTALL_PREFIX}/tools/ovsh

ip2mac()
{
	$timeout_kill 5 sh -x <<-. | grep .
		while ! ip -4 neigh show to $remote_ip dev $parent \
				| awk '{print \$3}' \
				| sed 1q \
				| grep .
		do
			$timeout_kill 1 ping -c 1 $remote_ip >/dev/null
		done
.
}

ip link add link $parent name $ifname type softwds
cd /sys/class/net/$ifname/softwds
echo Y > wrap
echo $local_ip > ip4gre_local_ip
echo $remote_ip > ip4gre_remote_ip
addr=$(
	( test -n "$remote_mac" && test "$remote_mac" != 00:00:00:00:00:00 && echo "$remote_mac" ) || \
	( iwconfig "$parent" | grep -q Mode:Master  && $ovsh -r s DHCP_leased_IP hwaddr -w inet_addr==$remote_ip | grep . ) || \
	( iwconfig "$parent" | grep -q Mode:Managed && ip2mac | grep . )
)
echo -n "$(echo "$addr" | sed 1q)" > addr
