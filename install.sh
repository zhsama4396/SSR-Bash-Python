﻿#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#Check Root
[ $(id -u) != "0" ] && { echo "${CFAILURE}Error: You must be root to run this script${CEND}"; exit 1; }
#Check OS
if [ -n "$(grep 'Aliyun Linux release' /etc/issue)" -o -e /etc/redhat-release ];then
    OS=CentOS
    [ -n "$(grep ' 7\.' /etc/redhat-release)" ] && CentOS_RHEL_version=7
    [ -n "$(grep ' 6\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release6 15' /etc/issue)" ] && CentOS_RHEL_version=6
    [ -n "$(grep ' 5\.' /etc/redhat-release)" -o -n "$(grep 'Aliyun Linux release5' /etc/issue)" ] && CentOS_RHEL_version=5
elif [ -n "$(grep 'Amazon Linux AMI release' /etc/issue)" -o -e /etc/system-release ];then
    OS=CentOS
    CentOS_RHEL_version=6
elif [ -n "$(grep bian /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Debian' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Deepin /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Deepin' ];then
    OS=Debian
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Debian_version=$(lsb_release -sr | awk -F. '{print $1}')
elif [ -n "$(grep Ubuntu /etc/issue)" -o "$(lsb_release -is 2>/dev/null)" == 'Ubuntu' -o -n "$(grep 'Linux Mint' /etc/issue)" ];then
    OS=Ubuntu
    [ ! -e "$(which lsb_release)" ] && { apt-get -y update; apt-get -y install lsb-release; clear; }
    Ubuntu_version=$(lsb_release -sr | awk -F. '{print $1}')
    [ -n "$(grep 'Linux Mint 18' /etc/issue)" ] && Ubuntu_version=16
else
    echo "${CFAILURE}Does not support this OS, Please contact the author! ${CEND}"
    kill -9 $$
fi
#Set DNS
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
#Install Basic Tools
if [[ ${OS} == Ubuntu ]];then
	apt-get update
	apt-get install python -y
	apt-get install python-pip -y
	apt-get install git -y
	apt-get install language-pack-zh-hans -y
fi
if [[ ${OS} == CentOS ]];then
	yum install python -y
	yum install python-setuptools -y && easy_install pip -y
	yum install git -y
fi
if [[ ${OS} == Debian ]];then
	apt-get update
	apt-get install python -y
	apt-get install python-pip -y
	apt-get install git -y
fi

#Install SSR and SSR-Bash
cd /usr/local
git clone https://github.com/shadowsocksr/shadowsocksr.git
git clone https://github.com/FunctionClub/SSR-Bash-Python.git
cd /usr/local/shadowsocksr
bash initcfg.sh

#Install SSR-Bash Background
wget -N --no-check-certificate -O /usr/local/bin/ssr https://raw.githubusercontent.com/FunctionClub/SSR-Bash-Python/master/ssr
chmod +x /usr/local/bin/ssr

#Modify ShadowsocksR API
sed -i "s/sspanelv2/mudbjson/g" /usr/local/shadowsocksr/userapiconfig.py
sed -i "s/UPDATE_TIME = 60/UPDATE_TIME = 10/g" /usr/local/shadowsocksr/userapiconfig.py
#INstall Success
echo '安装完成！输入 ssr 即可使用本程序~'
echo '欢迎加QQ群：277717865 讨论交流哦~'
