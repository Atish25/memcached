#!/bin/bash
echo " ATISH DAS "
#
if [ -e '/usr/bin/memcached' ]; then
service memcached restart && chkconfig memcached on;
  else
yum install memcached -y && service memcached restart && chkconfig memcached on;
 fi
if [ -e '/usr/bin/memcached' ]; then
ex -sc '%s/OPTIONS=""/OPTIONS="-l 127.0.0.1"/g|x' /etc/sysconfig/memcached && service memcached restart;
else
yum install memcached -y && ex -sc '%s/OPTIONS=""/OPTIONS="-l 127.0.0.1"/g|x' /etc/sysconfig/memcached && service memcached restart;
fi
if [ -e '/usr/bin/netstat' ]; then
netstat -an | grep ":11211" 
else
yum install net-tools -y && yum install curl -y;
fi
echo -e "\e[31;43m*****DISABLE IPV6 *****\e[0m"
sysctl -w net.ipv6.conf.all.disable_ipv6=1
#publicip=curl icanhazip.com
publicip=$(curl icanhazip.com)
if [ -e '/usr/bin/nmap' ]; then
echo -e "\e[31;43m*****CHECK MEMCACHED PORT STATUS *****\e[0m" && nmap -p 11211 $publicip
 else
yum install nmap -y && echo -e "\e[31;43m*****CHECK MEMCACHED PORT STATUS *****\e[0m" && nmap -p 11211 $publicip
rm -rf memcache.sh
exit 1
fi
rm -rf memcache.sh
