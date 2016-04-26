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

service ssh restart;

dpkg-reconfigure tzdata;

# Webmin

apt-get install perl libnet-ssleay-perl openssl libauthen-pam-perl libpam-runtime
libio-pty-perl apt-show-versions python;

wget http://prdownloads.sourceforge.net/webadmin/webmin_1.791_all.deb;

dpkg --install webmin_1.791_all.deb;

service webmin restart;

# remove unused

apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove sendmail*;
apt-get -y --purge remove bind9*;

# update

apt-get update; apt-get -y upgrade;

# install webserver

apt-get -y install nginx php5-fpm php5-cli;

# disable exim

service exim4 stop
sysv-rc-conf exim4 off

# update apt-file
apt-file update

# setting vnstat

vnstat -u -i venet0
service vnstat restart

# install screenfetch
cd
wget 'https://raw.github.com/yurisshOS/debian7os/master/screeftech-dev'
mv screeftech-dev /usr/bin/screenfetch;
chmod +x /usr/bin/screenfetch;
echo "clear" >> .profile
echo "screenfetch" >> .profile


# install dropbear

apt-get -y install dropbear;

sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear;

sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=443/g' /etc/default/dropbear;

echo "/bin/false" >> /etc/shells;

service dropbear restart;


# install fail2ban

apt-get -y install fail2ban;

service fail2ban restart;

# install squid3

apt-get update;apt-get -y install wget curl;

wget https://raw.githubusercontent.com/baymaxbhai/debian7os/master/squid;

chmod 100 squid.sh;

./squid.sh;

service squid3 restart;


#linux-dash

apt-get install apache2 apache2-utils;

apt-get install php5 curl php5-curl php5-json;

apt-get install git;

service apache2 start;

cd /var/www/html;

git clone https://github.com/afaqurk/linux-dash.git;

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
echo "0 */12 * * * root /sbin/reboot" > /etc/cron.d/reboot
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
chown -R www-data:www-data /home/vps/public_html
service cron restart
service vnstat restart
service openvpn restart
service ssh restart
service dropbear restart
service fail2ban restart
service squid3 restart
service webmin restart
rm -rf ~/.bash_history && history -c
echo "unset HISTFILE" >> /etc/profile

# info
clear
echo ""  | tee -a log-install.txt
echo "AUTOSCRIPT INCLUDES" | tee log-install.txt
echo "===============================================" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "Service"  | tee -a log-install.txt
echo "Dropbear : 443, 110, 109"  | tee -a log-install.txt
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
echo "VPS AUTO REBOOT TIAP 12 JAM"  | tee -a log-install.txt
echo "SILAKAN REBOOT VPS ANDA"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "http://ip-anda/linux-dash"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "==============================================="  | tee -a log-install.txt
cd
rm -f /root/debian7.sh