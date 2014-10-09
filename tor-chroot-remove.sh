#!/bin/bash
#elaborado por sinfallas
TORCHROOT=/opt/chroot_tor/
rm $TORCHROOT -rfv 
rm /etc/default/tor -rfv 
rm /etc/init.d/tor-chroot -rfv 
userdel tor -f 
exit 0
