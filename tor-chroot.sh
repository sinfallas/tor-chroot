#!/bin/bash
export TORCHROOT=/opt/torchroot
apt-get -y install tor

if [ `grep "tor" /etc/passwd | wc -l` -eq 0 ]; then
	adduser --disabled-login --no-create-home --home /var/lib/tordata --shell /bin/false --gecos "Tor user,,," tor || fail "no se pudo crear usuario tor"        
	echo -e "[*] Se crea usuario tor"
else
	echo -e "[*] Usuario tor ya existe"
fi



mkdir -p $TORCHROOT
mkdir -p $TORCHROOT/etc/tor
mkdir -p $TORCHROOT/dev
mkdir -p $TORCHROOT/usr/bin
mkdir -p $TORCHROOT/usr/lib
mkdir -p $TORCHROOT/var/lib
mkdir -p $TORCHROOT/var/run/tor/
mkdir -p $TORCHROOT/var/lib/tordata/
mkdir -p $TORCHROOT/var/log/tor/
mknod -m 644 $TORCHROOT/dev/random c 1 8
mknod -m 644 $TORCHROOT/dev/urandom c 1 9
mknod -m 666 $TORCHROOT/dev/null c 1 3

ln -s /usr/lib $TORCHROOT/lib
cp -v /etc/hosts $TORCHROOT/etc/
cp -v /etc/host.conf $TORCHROOT/etc/
cp -v /etc/localtime $TORCHROOT/etc/
cp -v /etc/nsswitch.conf $TORCHROOT/etc/
cp -v /etc/resolv.conf $TORCHROOT/etc/
cp -v /etc/tor/torrc $TORCHROOT/etc/tor/
cp -v /usr/share/GeoIP/GeoIP.dat $TORCHROOT/tor/share/tor/geoip

sh -c "grep tor /etc/passwd > $TORCHROOT/etc/passwd"
sh -c "grep tor /etc/group > $TORCHROOT/etc/group"






cp /usr/bin/tor         $TORCHROOT/usr/bin/
cp /lib/libnss* /lib/libnsl* /lib/ld-linux.so* /lib/libresolv* /lib/libgcc_s.so* $TORCHROOT/usr/lib/
cp $(ldd /usr/bin/tor | awk '{print $3}'|grep --color=never "^/") $TORCHROOT/usr/lib/
cp -r /var/lib/tor      $TORCHROOT/var/lib/
chown -R tor:tor $TORCHROOT/var/lib/tor

chroot --userspec=tor:tor /opt/torchroot /usr/bin/tor 

exit 0
