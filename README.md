install docker.sh 脚本使用方法： sh install_docekr.sh  docker-version <default aliyun-docker.repo>

Docker_install.sh  该脚本采用传参的形式，直接sh执行即可




私有Docker Harbor 搭建

环境配置，docker harbor主机名设置为harbor，方便为了后续给harbor签发证书

系统：centos —— 4c8G

磁盘容量：100Gb

工作目录:/data

提前生成证书

openssl genrsa -out ca.key 3072
openssl req -new -x509 -days 3650 -key ca.key -out ca.pem
![图片](https://user-images.githubusercontent.com/85480356/177931824-3a41fa14-f098-4515-8b06-d4cedbeb1c03.png)

openssl genrsa -out harbor.key  3072
openssl req -new -key harbor.key -out harbor.csr
![图片](https://user-images.githubusercontent.com/85480356/177934387-0e3643fc-dbc7-4ce5-a0ad-1ee5f2669b3b.png)

openssl x509 -req -in harbor.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out harbor.pem -days 3650
![图片](https://user-images.githubusercontent.com/85480356/177932028-ef0320b6-733c-4f80-b4bb-e52a04848332.png)


基础环境配置

[root@ harbor~]# systemctl stop firewalld && systemctl disable firewalld

关闭iptables防火墙

[root@ harbor~]# yum install iptables-services -y  #安装iptables

禁用iptables

root@ harbor~]# service iptables stop   && systemctl disable iptables

清空防火墙规则

[root@ harbor~]# iptables -F 

关闭selinux

[root@ harbor~]# setenforce 0

[root@harbor~]# sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config #永久关闭selinux，需要重启才可以生效

修改/etc/hosts

ipaddress harbor

添加docker源

docker官网地址：https://docs.docker.com/get-started/

yum-config-manager  --add-repo   https://download.docker.com/linux/centos/docker-ce.repo
yum install docker-ce docker-ce-cli containerd.io docker-compose-plugin
 
开启包转发功能、修改内核参数

[root@ harbor~]# modprobe br_netfilter

[root@ harbor~]# cat > /etc/sysctl.d/docker.conf <<EOF
                                                       
net.bridge.bridge-nf-call-ip6tables = 1
                                                       
net.bridge.bridge-nf-call-iptables = 1
                                                       
net.ipv4.ip_forward = 1
                                                       
EOF
                                                       
[root@harbor ~]# sysctl -p /etc/sysctl.d/docker.conf
                                                       
重启docker
                                                                                                             
harbor下载地址：https://github.com/goharbor/harbor/releases
                                                       
下载安装并解压
修改harbor.yml 配置文件                                                       
 ![图片](https://user-images.githubusercontent.com/85480356/177937175-a89152c7-fd03-412d-aa86-be5a8d93ef63.png)

./install.sh

docker ps -a #所有的container即可访问

本地配置hosts文件解析   IP harbor

故障分析
![图片](https://user-images.githubusercontent.com/85480356/177937624-316bc355-8b62-47e0-82b1-2968389be86c.png)

修改/etc/docker/daemon.json 文件，添加dockerharbor 地址即可
                                                       
Eg:
                                                       
{
"registry-mirrors": ["https://rsbud4vc.mirror.aliyuncs.com","https://registry.dockercn.com","https://docker.mirrors.ustc.edu.cn","https://dockerhub.azk8s.cn","http://hubmirror.c.163.com"],
"insecure-registries": ["ip","harbor"]
}
  
重启docker

harbor环境重置

./prepare
                                                       
docker-compose down -v
                                                       
docker-compose  up -d
                                                       

                                                     
                                                       
                                                       
