echo 600 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout
echo 600 > /proc/sys/net/netfilter/nf_conntrack_udp_timeout_stream

# Enable conntrack_helper
echo 1 > /proc/sys/net/netfilter/nf_conntrack_helper

