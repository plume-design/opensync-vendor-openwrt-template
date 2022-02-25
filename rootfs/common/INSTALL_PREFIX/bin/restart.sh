#!/bin/sh
/etc/init.d/opensync stop
/etc/init.d/wpad restart
/etc/init.d/openvswitch restart
sleep 1
/etc/init.d/opensync start
