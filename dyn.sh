#!/bin/sh
host=yourhostname.com.net.org # Your domain name on Google
host2=yoursecondhost.com # Your domain name on Google
user1=crypticpass # View dynamic DNS credentials on Google!
pass1=crypticpass # View dynamic DNS credentials on Google!
user2=crypticuser # View dynamic DNS credentials on Google!
pass2=crypticuser # View dynamic DNS credentials on Google!
ipfile=http://somewhereonthenet/ip.php # Your ip.php file, if you want to use it
email=derp@douchecanoe.net

old=$(nslookup $host |  awk '/Name:/{val=$NF;flag=1;next} /Address:/ && flag{print $NF}')
gateway=$(ip r | sed -En 's/127.0.0.1//;s/.*via (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p')
if [ "$old" = "$gateway" ]; then
   echo "$host is not $old" | mail -s "IP error for `hostname`" $email
   exit 1
fi

if [ ! -z "$old" ]; then
   echo "$old" > ~/.oldip.txt
  else
   old=`cat ~/.oldip.txt`
fi
new=$(wget -qO- $ipfile)
if [ ! -n "$new" ]; then
  new=$(wget -q -O - http://icanhazip.com/)
fi
if [ ! -n "$new" ]; then
  new=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
fi
if [ ! -n "$new" ]; then
  new=$(dig +short myip.opendns.com @resolver1.opendns.com)
fi
if [ ! -n "$new" ]; then
  echo "Unable to get current IP, possibly offline"
  exit 1 
fi
if [ "$old" = "$new" ]; then
   exit 0
  else
    wget -O dyn.txt -q https://$user1:$pass1@domains.google.com/nic/update?hostname=$host
    wget -O dyn.txt -q https://$user2:$pass2@domains.google.com/nic/update?hostname=$host2
    echo "The IP address has changed on `date +%Y-%m-%d` `date +%H:%M` from $old to $new" | mail -s "The IP for `hostname` has changed" $email
fi
