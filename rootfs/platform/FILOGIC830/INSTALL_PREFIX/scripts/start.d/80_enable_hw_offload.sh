#!/bin/sh

echo "Enable HW Offload"
echo 1 > /sys/kernel/debug/xt_flowoffload/enable
