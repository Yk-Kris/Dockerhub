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
                                                      
                                                       
                                                       
                                                       
                                                       
