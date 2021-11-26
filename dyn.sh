#!/bin/sh
host=myhome.mydomain.net.com # Your domain name on Google
user=jIjfYhhhtY873blah # View dynamic DNS credentials on Google!
pass=JeNnY8675309-8484 # View dynamic DNS credentials on Google!
ipfile=mydomain.net.com/ip.php # Your ip.php file, if you want to use it
email=myemail@gmail.com

timestamp=$( date +%Y-%m-%d_%H:%M )
old=$(nslookup $host |  awk '/Name:/{val=$NF;flag=1;next} /Address:/ && flag{print $NF}') # asks locally what your IP is for the Dynamic DNS
new=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}') # Asks Google for your IP - only use ONE, comment others out!
# new=$(dig +short myip.opendns.com @resolver1.opendns.com) # Asks OpenDNS for your IP - only use ONE, comment others out!
# new=$(wget -qO- $ipfile) # Asks your site for your IP - only use ONE, comment others out!
if [ "$old" = "$new" ]; then
   echo "IP is unchanged... this is for testing" >>/dev/null 2>&1
   else
   echo "IP changed at $timestamp from  $old to $new" >> ~/scripts/IPs.txt
   wget -O dyn.txt -q https://$user:$pass@domains.google.com/nic/update?hostname=$host
   echo "The IP address has changed on `date +%Y-%m-%d` at `date +%H:%M` from $old to $new" | mail -s "The IP on `$HOSTNAME` has changed" $email
fi
