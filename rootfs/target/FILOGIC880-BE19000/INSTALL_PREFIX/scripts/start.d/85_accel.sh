#!/bin/sh

# We set RPS for
# - eth interfaces
echo e | tee /sys/class/net/eth0/queues/rx*/rps_cpus
echo e | tee /sys/class/net/eth1/queues/rx*/rps_cpus
