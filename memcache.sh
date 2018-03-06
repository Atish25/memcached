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
cd /etc/csf/ && sh /etc/csf/uninstall.sh
cd /usr/src && wget https://download.configserver.com/csf.tgz && tar -xzf csf.tgz && cd csf && sh install.sh

ex -sc '%s/RESTRICT_SYSLOG = "0"/RESTRICT_SYSLOG = "2"/g|x' /etc/csf/csf.conf

ex -sc '%s/AUTO_UPDATES = "1"/AUTO_UPDATES = "0"/g|x' /etc/csf/csf.conf

ex -sc '%s/TCP_IN = "20,21,22,25,53,80,110,143,443,465,587,993,995,2077,2078,2079,2080,2082,2083,2086,2087,2095,2096"/TCP_IN = "20,21,22,25,53,80,110,143,443,465,587,993,995,2077,2078,2079,2080,2083,2087,49152:65534,2096"/g|x' /etc/csf/csf.conf

ex -sc '%s/TCP_OUT = "20,21,22,25,37,43,53,80,110,113,443,587,873,993,995,2086,2087,2089,2703"/TCP_OUT = "20,21,22,25,37,43,53,80,110,113,443,587,873,993,995,2086,2087,2089,2703,49152:65534,2096"/g|x' /etc/csf/csf.conf

cat <<EOT >> /etc/csf/csf.allow
180.87.240.74/29
111.93.172.122/29
103.250.86.42/29
118.185.76.18/29
203.171.33.10
api.konnektive.com
80.248.30.132
EOT

ex -sc '%s/TESTING = "1"/"TESTING = "0"/g|x' /etc/csf/csf.conf && service csf restart
service csf restart
rm -rf memcache.sh
exit 1
fi
rm -rf memcache.sh
