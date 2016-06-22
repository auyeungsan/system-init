#!/bin/bash

iptables -F

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 9090 -j ACCEPT
iptables -A INPUT -s 127.0.0.1 -p udp --dport 514 -j ACCEPT
iptables -A INPUT -s 210.5.180.82 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -s 223.197.136.101 -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -s 223.197.54.56,223.197.54.57,223.197.54.58,223.197.54.59,223.197.54.60,223.197.54.61,223.197.54.62,223.197.54.63 -p tcp --dport 22 -j ACCEPT
#iptables -A INPUT -p tcp --dport 22 -j DROP
iptables -P INPUT DROP



#source NAT

#iptables -t nat -A POSTROUTING -s $SERV_IP2 -o eth0 -j SNAT --to $NAT_IP
#iptables -t nat -A POSTROUTING -s $SERV_IP -o eth0 -j SNAT --to $NAT_IP

#Destination NAT
#iptables -t nat -A PREROUTING -d $NAT_IP -i eth0 -p tcp --dport 80 -j DNAT --to $SERV_IP:80
#iptables -t nat -A PREROUTING -d $NAT_IP -i eth0 -p tcp --dport 443 -j DNAT --to $SERV_IP:443
#iptables -t nat -A PREROUTING -d $NAT_IP -i eth0 -p tcp --dport 80 -j DNAT --to $SERV_IP:80
#iptables -t nat -A PREROUTING -d $NAT_IP -i eth0 -p tcp --dport 443 -j DNAT --to $SERV_IP:443
