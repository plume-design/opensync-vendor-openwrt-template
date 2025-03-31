#!/bin/sh
#
# Set the lowest possible tx_power on all interfaces
# Mediatek ref platform will be used mainly in shieldbox
# where devices are very close each other
#
# Remove this file if you plan to do long range communication

mwctl dev rax0 set pwr PercentageCtrl=1
mwctl dev rai0 set pwr PercentageCtrl=1
mwctl dev ra0 set pwr PercentageCtrl=1
mwctl dev rax0 set pwr PowerDropCtrl=1
mwctl dev rai0 set pwr PowerDropCtrl=1
mwctl dev ra0 set pwr PowerDropCtrl=1

