#!/bin/sh
#
# Set regulatory domain if unset
#

country=GB

if [ `iw reg get | grep country | awk -F':' '{ print $1}' | awk -F' ' '{ print $2}'` == "00" ] ; then
    iw reg set $country
fi
