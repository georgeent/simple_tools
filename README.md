# simple_tools
The simple tools set for daily using.


1 kick_weak_clients.sh

Description:   Kick weak signal clients off from AP (lower then -72dBm). It used for multi-access-point environment.

Writed by George. 
https://www.entrance.online
https://www.entrance.online/%E5%8D%9A%E5%AE%A2/



#Runs on Openwrt 18.06 with hostapd-utils

installing:

opkg update 

opkg install hostapd-utils

hostapd-utils -h



mkdir /etc/tools

#Download the shell script

chmod 750 kick_weak_clients.sh

mv kick_weak_clients.sh /etc/tools/

/etc/tools/kick_weak_clients.sh 

echo '* * * * * /etc/tools/kick_weak_clients.sh &>/dev/null' >> /etc/crontabs/root
