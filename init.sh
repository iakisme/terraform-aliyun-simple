#!/bin/bash
wget http://dao-get.daocloud.io/ossfs_1.80.5_centos7.0_x86_64.rpm
yum install -y ossfs_1.80.5_centos7.0_x86_64.rpm
echo wangkai-test-2020:key:secret > /etc/passwd-ossfs
chmod 640 /etc/passwd-ossfs
mkdir /root/my-bucket
ossfs wangkai-test-2020 /root/my-bucket -ourl=http://oss-cn-hangzhou-internal.aliyuncs.com
