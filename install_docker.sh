
#!/usr/bin/env bash
set -e
# Color
color_green="\033[32m"
color_red="\033[31m"
res="\033[0m"
echo -e "${color_green}============Install Docker============${res}"
echo -e "${color_red}【1】Remove docker...${res}"
yum remove docker
yum remove docker docker-common docker-selinux docker-engine
# Locate shell script path
SCRIPT_DIR=$(dirname $0)
if [ ${SCRIPT_DIR} != '.' ]
then
  cd ${SCRIPT_DIR}
fi
echo -e "${color_red}【2】Install yum-utils/device-mapper-persistent-data/lvm2...${res}"
yum install -y yum-utils device-mapper-persistent-data lvm2
echo -e "${color_red}【3】Add aliyun repo...${res}"
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
echo -e "${color_red}【4】Makecache...${res}"
yum makecache fast
echo -e "${color_red}【5】Install docker-ce...${res}"
VERSION="$1"
if [ -n "$VERSION" ] ; then
    yum -y install docker-ce-${VERSION} docker-ce-cli-${VERSION}
else
    yum -y install docker-ce
fi
echo -e "${color_red}【6】 Start and set docker...${res}"
systemctl start docker 
systemctl enable docker
echo -e "${color_red}【7】 Docker Info...${res}"
docker info
