#!/bin/sh
host=myhome.mydomain.net.com # Your domain name on Google
user=jIjfYhhhtY873blah # View dynamic DNS credentials on Google!
pass=JeNnY8675309-8484 # View dynamic DNS credentials on Google!
ipfile=mydomain.net.com/ip.php # Your ip.php file, if you want to use it
email=myemail@gmail.com
old=$(nslookup $host |  awk '/Name:/{val=$NF;flag=1;next} /Address:/ && flag{print $NF}') 
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
   wget -O dyn.txt -q https://$user:$pass@domains.google.com/nic/update?hostname=$host
   echo "The IP address has changed on `date +%Y-%m-%d` at `date +%H:%M` from $old to $new" | mail -s "The IP on `$HOSTNAME` has changed" $email
fi
