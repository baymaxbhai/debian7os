#!/bin/sh

# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0'`;
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# install wget and curl

apt-get update;apt-get -y install wget curl;

# set time GMT +8

ln -fs /usr/share/zoneinfo/Asia/Kuala_Lumpur /etc/localtime;

# set locale

sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config;

/etc/init.d/ssh restart 

dpkg-reconfigure tzdata;

# update

apt-get update; apt-get -y upgrade;

# install webserver

apt-get -y install nginx php5-fpm php5-cli;

# disable exim

/etc/init.d/exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# install screenfetch
cd
wget 'https://raw.githubusercontent.com/baymaxbhai/debian7os/master/screeftech-dev'
mv screeftech-dev /usr/bin/screenfetch;
chmod +x /usr/bin/screenfetch;
echo "clear" >> .profile
echo "screenfetch" >> .profile


# install webserver

cd

rm /etc/nginx/sites-enabled/default

rm /etc/nginx/sites-available/default

wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/nginx.conf"

mkdir -p /home/vps/public_html

echo "<pre>Modified by Baymax_Bhai OpenSource</pre>" > /home/vps/public_html/index.html

echo "<?php phpinfo(); ?>" > /home/vps/public_html/info.php

wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/vps.conf"

sed -i 's/listen = \/var\/run\/php5-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php5/fpm/pool.d/www.conf

/etc/init.d/php5-fpm restart

/etc/init.d/nginx restart

# install dropbear
apt-get -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS=""/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells

# install mrtg

wget -O /etc/snmp/snmpd.conf "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/snmpd.conf"

wget -O /root/mrtg-mem.sh "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/mrtg-mem.sh"

chmod +x /root/mrtg-mem.sh

cd /etc/snmp/

sed -i 's/TRAPDRUN=no/TRAPDRUN=yes/g' /etc/default/snmpd

/etc/init.d/snmpd restart

snmpwalk -v 1 -c public localhost 1.3.6.1.4.1.2021.10.1.3.1

mkdir -p /home/vps/public_html/mrtg

cfgmaker --zero-speed 100000000 --global 'WorkDir: /home/vps/public_html/mrtg' --output /etc/mrtg.cfg public@localhost

curl "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/mrtg.conf" >> /etc/mrtg.cfg

sed -i 's/WorkDir: \/var\/www\/mrtg/# WorkDir: \/var\/www\/mrtg/g' /etc/mrtg.cfg

sed -i 's/# Options\[_\]: growright, bits/Options\[_\]: growright/g' /etc/mrtg.cfg

indexmaker --output=/home/vps/public_html/mrtg/index.html /etc/mrtg.cfg

if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi

if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi

if [ -x /usr/bin/mrtg ] && [ -r /etc/mrtg.cfg ]; then mkdir -p /var/log/mrtg ; env LANG=C /usr/bin/mrtg /etc/mrtg.cfg 2>&1 | tee -a /var/log/mrtg/mrtg.log ; fi

cd


# install fail2ban

apt-get -y install fail2ban

/etc/init.d/fail2ban restart


# install squid3

cd

apt-get update;apt-get -y install wget curl

wget https://raw.githubusercontent.com/baymaxbhai/debian7os/master/squid

chmod 100 squid.sh

./squid.sh

/etc/init.d/squid3 restart


# download script

cd
wget https://raw.githubusercontent.com/baymaxbhai/debian7os/master/trial.sh
wget -O speedtest_cli.py "https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py"
wget -O bench-network.sh "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/bench-network.sh"
wget -O ps_mem.py "https://raw.github.com/pixelb/ps_mem/master/ps_mem.py"
wget -O dropmon "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/dropmon.sh"
wget -O userlogin.sh "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/userlogin.sh"
wget -O userexpired.sh "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/userexpired.sh"
wget -O userlimit.sh "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/userlimit.sh"
wget -O expire.sh "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/expire.sh"
wget -O autokill.sh "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/autokill.sh"
wget -O /etc/issue.net "https://raw.githubusercontent.com/baymaxbhai/debian7os/master/banner"
echo "@reboot root /root/userexpired.sh" > /etc/cron.d/userexpired
cho "@reboot root /root/userlimit.sh" > /etc/cron.d/userlimit
echo "0 */23 * * * root /sbin/reboot" > /etc/cron.d/reboot
echo "* * * * * service dropbear restart" > /etc/cron.d/dropbear
echo "@reboot root /root/autokill.sh" > /etc/cron.d/autokill
sed -i '$ i\screen -AmdS check /root/autokill.sh' /etc/rc.local

chmod +x bench-network.sh
chmod +x speedtest_cli.py
chmod +x ps_mem.py
chmod +x userlogin.sh
chmod +x userexpired.sh
chmod +x userlimit.sh
chmod +x autokill.sh
chmod +x dropmon
chmod +x expire.sh
chmod +x trial.sh

# finishing

/etc/init.d/cron restart
/etc/init.d/openvpn restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/squid3 restart
/etc/init.d/webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

apt-get -f install

apt-get update

# info
clear
echo ""  | tee -a log-install.txt
echo "AUTOSCRIPT INCLUDES" | tee log-install.txt
echo "===============================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "Dropbear : 443"  | tee -a log-install.txt
echo "Squid3   : 8080 (limit to IP SSH)"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script"  | tee -a log-install.txt
echo "------"  | tee -a log-install.txt
echo "screenfetch"  | tee -a log-install.txt
echo "./ps_mem.py"  | tee -a log-install.txt
echo "./speedtest_cli.py --share"  | tee -a log-install.txt
echo "./bench-network.sh"  | tee -a log-install.txt
echo "./userlogin.sh" | tee -a log-install.txt
echo "./userexpired.sh" | tee -a log-install.txt
echo "./userlimit.sh 2 [ini utk melimit max 2 login]" | tee -a log-install.txt
echo "sh dropmon [port] contoh: sh dropmon 443" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "lain-lain"  | tee -a log-install.txt
echo "----------"  | tee -a log-install.txt
echo "Webmin   : https://$MYIP:10000/"  | tee -a log-install.txt
echo "Timezone : Asia/Kuala_Lumpur"  | tee -a log-install.txt
echo "Fail2Ban : [on]"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Script Modified by Baymax"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "VPS AUTO REBOOT TIAP 24 JAM"  | tee -a log-install.txt
echo "SILAKAN REBOOT VPS ANDA"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "http://ip-anda/linux-dash"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==============================================="  | tee -a log-install.txt
cd
rm -f /root/debian7.sh

#reboot

shutdown -r +5
