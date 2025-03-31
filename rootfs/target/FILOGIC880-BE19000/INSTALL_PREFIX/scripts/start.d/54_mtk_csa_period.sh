#!/bin/sh
#
# Align Channel Switch Annoucment cs count to other platforms

mwctl dev rax0 set CSAPeriod=15
mwctl dev rai0 set CSAPeriod=15
mwctl dev ra0 set CSAPeriod=15
