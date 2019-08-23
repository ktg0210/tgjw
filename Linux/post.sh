#!/bin/bash

############# By taegu.kang ######## 20190724 ############## amzlinux 2, Centos 7

## install essential packages and update
rpm -Uvh https://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
yum install -y vim sysstat curl nmap wget unzip yum-utils bind-utils telnet mysql-community-client
yum update -y


## Syslog flooding
echo 'if $programname == "systemd" and ($msg contains "Starting Session" or $msg contains "Started Session" or $msg contains "Created slice" or $msg contains "Starting user-" or $msg contains "Starting User Slice of" or $msg contains "Removed session" or $msg contains "Removed slice User Slice of" or $msg contains "Stopping User Slice of") then stop' >/etc/rsyslog.d/ignore-systemd-session-slice.conf

## motd customoize
cat /dev/null > /etc/motd

case "`cat /etc/system-release | awk '{print$1}'`" in
Amazon)
chmod -x /etc/update-motd.d/* >&/dev/null
cat <<EOF>/etc/update-motd.d/80-stats
#!/bin/sh
echo "-----"
uptime
echo "-----"
df -h
EOF
chmod +x /etc/update-motd.d/80-stats
update-motd
;;
*)
cat <<EOF>/etc/profile.d/motd.sh
#!/bin/sh
echo "-----"
uptime
echo "-----"
df -h
EOF
chmod +x /etc/profile.d/motd.sh
update-motd
;;
esac


## sar period 10 to 1
sed -i '1,2 s/10/1/' /etc/cron.d/sysstat

## dev, admin user
useradd dev
useradd user
groupadd -g 777 grp
useradd -u 777 -g grp user
usermod -G wheel user
echo 'password' | passwd --stdin user

cat << EOF > /etc/sudoers.d/hodoo

# User rules for hodoo
dev ALL=(ALL)ALL,!/bin/su
hodoo ALL=(ALL) NOPASSWD:ALL
EOF

## modify sshd config
cp /etc/ssh/sshd_config /etc/ssh/sshd_conf.bak
sed -i -e 's/^PasswordAuthentication no/#PasswordAuthentication no/' -e 's/#PasswordAuthentication no/PasswordAuthentication yes/' -e 's/UseDNS yes/UseDNS no/' -e 's/#Port 22/Port 20022/' /etc/ssh/sshd_config

## copy key file to admin user
cp -apr /home/ec2-user/.ssh/ /home/user/
chown -R hodoo.hodoo /home/user/.ssh/

## increase open file limits
cat << EOF > /etc/security/limits.d/70-hodoo.conf
*       hard    nofile  20480
*       soft    nofile  20480
EOF


## history and session timeout
cp /etc/profile /etc/profile.bak
cat << EOF >> /etc/profile

# session time out and timestamp for history file
export TMOUT=600
export HISTFILE=/root/.bash_history-$SUDO_USER
HISTTIMEFORMAT="%F %T "
EOF

## disable session log message flooding
''echo 'if $programname == "systemd" and ($msg contains "Starting Session" or $msg contains "Started Session" or $msg contains "Created slice" or $msg contains "Starting user-") then stop'>/etc/rsyslog.d/ignore-systemd-session-slice.conf''

## disable selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/sysconfig/selinux

## disable and stop cloud-init
systemctl disable cloud-config.target cloud-config.service cloud-final.service cloud-init-local.service
systemctl stop cloud-config.target cloud-config.service cloud-final.service cloud-init-local.service
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl disable kdump
systemctl stop kdump
