#!/bin/bash

#Please run those commands under root access

echo 'starting add user infra and set key'

useradd -m -s /bin/bash infra
echo 'infra:qSPrBMH35xEC'| chpasswd
mkdir -p /home/infra/.ssh
chmod 700 /home/infra/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAyiXX0ofy6YBEiDjEOSTf1m6R4XNzN5DNT9uRV7JcfOdEnjgtqSE+N34ExKbHXSRzs+rjr0W9CwCquNMQWQFTSgbrNkGfDDbYgoaFyXAhM0+zIngTJEs+NF6j0yjdEgWx2g31zpbW+recxgtW+7ranh4kd6WohtMian3Ph/sef9dm+0P0SvStF8uxnK3LMk1OFH74axKORpTJ84U48Rz6EON3YXUXYlu2uCNQnwSC82qRl6kOXwNZdWOD69rCpsCa7gw+nj4FcxTt1OQ8tWKp0VXPqk+XxvrK2dizkt2r2QNfXmCtflfoDWvKxZwnvVjLFJTYxDLezqKcYf5XtOAxuw==" > /home/infra/.ssh/authorized_keys
chmod 700 /home/infra/.ssh/authorized_keys
chown -R infra:infra /home/infra/
cp -f /etc/sudoers /tmp/;chmod 644 /tmp/sudoers;echo "infra   ALL=(ALL:ALL) ALL" >> /tmp/sudoers;mv -f /tmp/sudoers /etc/;chown root:root /etc/sudoers;chmod 440 /etc/sudoers

echo 'done!!!'

echo 'start open-ssh hardening'

sed -i 's/^#KeyRegenerationInterval.*/KeyRegenerationInterval 3600/' /etc/ssh/sshd_config
sed -i 's/^#ServerKeyBits/ServerKeyBits/' /etc/ssh/sshd_config
sed -i 's/^#LogLevel/LogLevel/' /etc/ssh/sshd_config
sed -i 's/^#LoginGraceTime/LoginGraceTime/' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#StrictModes/StrictModes/' /etc/ssh/sshd_config
sed -i 's/^#RSAAuthentication/RSAAuthentication/' /etc/ssh/sshd_config
sed -i 's/^#PubkeyAuthentication/PubkeyAuthentication/' /etc/ssh/sshd_config
sed -i 's/^#RhostsRSAAuthentication/RhostsRSAAuthentication/' /etc/ssh/sshd_config
sed -i 's/^#HostbasedAuthentication/HostbasedAuthentication/' /etc/ssh/sshd_config
sed -i 's/^#IgnoreRhosts/IgnoreRhosts/' /etc/ssh/sshd_config
sed -i 's/^#PermitEmptyPasswords/PermitEmptyPasswords/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/^GSSAPIAuthentication/#GSSAPIAuthentication/' /etc/ssh/sshd_config
sed -i 's/^GSSAPICleanupCredentials/#GSSAPICleanupCredentials/' /etc/ssh/sshd_config
sed -i 's/^#X11DisplayOffset/X11DisplayOffset/' /etc/ssh/sshd_config
sed -i 's/^#PrintMotd.*/PrintMotd no/' /etc/ssh/sshd_config
sed -i 's/^#PrintLastLog/PrintLastLog/' /etc/ssh/sshd_config
sed -i 's/^#TCPKeepAlive/TCPKeepAlive/' /etc/ssh/sshd_config
echo "Allowusers infra" >> /etc/ssh/sshd_config
echo "ClientAliveCountMax 4" >> /etc/ssh/sshd_config
interval=`grep ClientAliveInterval /etc/ssh/sshd_config`; if [ "$interval" ];then sed -i 's/ClientAliveInterval.*/ClientAliveInterval 50/' /etc/ssh/sshd_config;else echo -e "ClientAliveInterval 15" >> /etc/ssh/sshd_config;fi
echo "###############################################################################################################" > /etc/issue
echo "#                                                   CAUTION!                                                  #" >> /etc/issue
echo "#                                   All connections are monitored and recorded                                #" >> /etc/issue
echo "#                          Disconnect IMMEDIATELY if you are not an authorized user!                          #" >> /etc/issue
echo "###############################################################################################################" >> /etc/issue
sed -i 's!#Banner.*!Banner /etc/issue!' /etc/ssh/sshd_config
if [ -e "/etc/init.d/sshd" ];then service sshd restart;else service ssh restart;fi
if [ -e "/etc/redhat-release" ];then echo "TMOUT=300" >> /etc/bashrc;echo "readonly TMOUT" >> /etc/bashrc;echo "export TMOUT" >> /etc/bashrc;else echo "TMOUT=300" >> /etc/bash.bashrc;echo "readonly TMOUT" >> /etc/bash.bashrc;echo "export TMOUT" >> /etc/bash.bashrc;fi

echo 'Done!!!'

echo 'starting stop unnecessary service and set time zone'

if [ -e "/etc/redhat-release" ];then service iptables stop;chkconfig iptables off;else ufw disable;fi
echo 0 >/selinux/enforce
sed -i 's/SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
if [ -e "/etc/redhat-release" ];then cp -rf /usr/share/zoneinfo/Asia/Singapore /etc/localtime;echo ZONE=\"Asia/Singapore\" > /etc/sysconfig/clock;else cp -rf /usr/share/zoneinfo/Asia/Singapore /etc/localtime;echo "Asia/Singapore" > /etc/timezone;fi

if [ -e "/etc/redhat-release" ];then service postfix stop;chkconfig postfix off;fi
if [ -e "/etc/redhat-release" ];then service yum-cron stop;chkconfig  yum-cron off;fi
if [ -e "/etc/redhat-release" ];then yum -y install ntp;service ntpd start;chkconfig ntpd on;else apt-get -y install ntp sysv-rc-conf;service ntp start;sysv-rc-conf ntp on;fi

echo 'Done!!!'

echo 'starting kernel hardening'

echo "kernel.exec-shield=1" >> /etc/sysctl.conf
echo "kernel.randomize_va_space=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.rp_filter=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_source_route=0" >> /etc/sysctl.conf
echo "net.ipv4.icmp_echo_ignore_broadcasts=1" >> /etc/sysctl.conf
echo "net.ipv4.icmp_ignore_bogus_error_messages=1" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.log_martians = 1" >> /etc/sysctl.conf
if [ -e "/etc/redhat-release" ];then echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf;echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf;echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6;echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6;else echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf;echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf;echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf;fi
echo 'Done!!!'

echo 'starting install usable softeware'
if [ -e "/etc/redhat-release" ];then yum -y install telnet nc epel-release;yum -y update;else apt-get -y install telnet;apt-get -y dist-upgrade;fi
echo 'Done!!!'


#enable messages log at ubuntu and disable tcp/udp 514 port;
echo 'staring enable messages log at ubuntu and disable tcp/udp 514 port'

if [ -e "/etc/redhat-release" ];then 
	sed -i 's/^$ModLoad imudp/$ModLoad imudp\n$UDPServerAddress 127.0.0.1 /' /etc/rsyslog.conf
	#sed -i 's/^$ModLoad imudp/#$ModLoad imudp/' /etc/rsyslog.conf 
	#sed -i 's/^$UDPServerRun 514/#$UDPServerRun 514/' /etc/rsyslog.conf
	sed -i 's/^$ModLoad imtcp/#$ModLoad imtcp/' /etc/rsyslog.conf
	sed -i 's/^$InputTCPServerRun 514/#$InputTCPServerRun 514/' /etc/rsyslog.conf
	service rsyslog restart
else 
	echo -e "*.=info;*.=notice;*.=warn;authpriv.none;cron.none,daemon.none;mail,news.none          -/var/log/messages" >> /etc/rsyslog.d/50-default.conf	
	echo -e "cron.*                          /var/log/cron.log" >> /etc/rsyslog.d/50-default.conf
	sed -i 's/*.*;auth,authpriv.none/*.*;auth,authpriv.none;cron.none;local2.none/' /etc/rsyslog.d/50-default.conf
	sed -i 's/^$ModLoad imudp/$ModLoad imudp\n$UDPServerAddress 127.0.0.1 /' /etc/rsyslog.conf
	#sed -i 's/^$ModLoad imudp/#$ModLoad imudp /' /etc/rsyslog.conf 
	#sed -i 's/^$UDPServerRun 514/#$UDPServerRun 514/' /etc/rsyslog.conf
	sed -i 's/^$ModLoad imtcp/#$ModLoad imtcp/' /etc/rsyslog.conf
	sed -i 's/^$InputTCPServerRun 514/#$InputTCPServerRun 514/' /etc/rsyslog.conf
	service rsyslog restart
fi
echo 'Done!!!'

