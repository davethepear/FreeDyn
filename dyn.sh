#!/bin/sh
domain=myhome.mydomain.net.com # Your domain name on Google

nc -z ns1.google.com 53 > /dev/null
if [ "$?" = "1" ]; then 
   echo "It's dead, Jim!"
   else
      timestamp=$( date +%Y-%m-%d_%H:%M )
      # old=$(nslookup $domain |  awk '/Name:/{val=$NF;flag=1;next} /Address:/ && flag{print $NF}')
      old=`cat /home/pi/scripts/ip.txt`
      new=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
      # new=$(wget -qO- http://www.linncountykansas.com/ip.php)
      # new=$(dig +short myip.opendns.com @resolver1.opendns.com)
      if [ "$old" = "$new" ]; then
         echo "IP is unchanged... this is for testing" >>/dev/null 2>&1
      else
         echo "IP changed at $timestamp from  $old to $new" >> ~/scripts/IPs.txt
         echo $new > /home/pi/scripts/ip.txt
