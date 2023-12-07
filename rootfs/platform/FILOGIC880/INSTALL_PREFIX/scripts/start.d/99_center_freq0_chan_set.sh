#!/bin/sh

# This script is the workaround on device side before cloud controller can push center_freq0_chan to device.
# Assume cloud using default channel 37 for 6G and set the correponding center chan based on HT mode.

ht_mode=$(ovsh -rU s Wifi_Radio_Config -w freq_band==6G ht_mode)
case $ht_mode in
    HT20)
        center_chan=37
        ;;
    HT40)
        center_chan=35
        ;;
    HT80)
        center_chan=39
        ;;
    HT160)
        center_chan=47
        ;;
    HT320)
        center_chan=63
        ;;
    *)
        exit 1
esac

ovsh u Wifi_Radio_Config -w freq_band==6G center_freq0_chan:=$center_chan
