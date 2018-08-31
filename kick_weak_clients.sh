#!/bin/ash
#Kick all clients when they have weak signal lower then -72dBm
#Writed by George. https://www.entrance.online     #https://www.entrance.online/%E5%8D%9A%E5%AE%A2/
#Runs on Openwrt 18.06 with hostapd-utils
#mkdir /etc/tools;chmod 750 kick_weak_clients.sh; cp kick_weak_clients.sh /etc/tools/
#echo '* * * * * /etc/tools/ick_weak_clients.sh &>/dev/null' >> /etc/crontabs/root

if [ -d  /tmp/wifi ];then
echo 'folder /tmp/wifi/ had been created' &>/dev/null
else
mkdir /tmp/wifi
fi
 
/usr/sbin/iw dev wlan0 station dump > /tmp/wifi/alldevices
/usr/sbin/iw dev wlan0 station dump |grep -e '^Station' |awk '{print $2}'> /tmp/wifi/maclist
howmanymac=`cat /tmp/wifi/maclist|wc -l`
if [ $howmanymac -eq 0 ];then
echo 'no users access to  ap' &>/dev/null
exit 1
fi




init_num=0
for i in `cat /tmp/wifi/maclist`;do
 init_num=$(($init_num+1)) 
 grep $i -A 26 /tmp/wifi/alldevices > /tmp/wifi/"$init_num.txt";
done

for j in `ls /tmp/wifi/*.txt`;do
user_signal=`grep -w 'signal:' $j|awk '{ print $2 }'|sed 's/-//'`
user_mac=`grep -e '^Station' $j|awk '{print $2}'`
#
if [ $user_signal -gt 72 ];then
echo $user_signal "kick $user_mac off from this AP "`date` >> /tmp/apstatus
/usr/sbin/hostapd_cli -i wlan0 deauthenticate $user_mac &>/dev/null
else
echo "$user_signal $user_mac is good" &>/dev/null
fi
done
rm -f /tmp/wifi/*.txt
