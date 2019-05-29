---
title: Centos7 下安装 Mysql 5.5
date: 2019-05-28 16:38:33
categories:
 - Linux
tags:
 - 开发环境
 - Mysql 安装
comments: true
toc: true
---
本文仅适用于个人开发学习的环境搭建参考，搭建步骤基于网络教程，因此可能有很多不严谨的地方，目的是做为笔记参考学习使用。

如果你觉得这篇文字像流水账一样无聊又没有看下去的欲望，可以跳过，翻阅我的其他博客文章。

### 卸载 Mysql 相关程序

卸载Mysql:

```sh
[root@localhost services]# find / -name mysql
[root@localhost services]# find / -name mysql|xargs rm -rf
```

卸载系统自带的Mariadb:
```sh
[root@localhost services]# rpm -qa|grep mariadb
mariadb-libs-5.5.56-2.el7.x86_64
[root@localhost services]# rpm -e --nodeps mariadb-libs-5.5.56-2.el7.x86_64
```

删除 etc 目录下的my.cnf（有则删除，没有忽略）
```sh
[root@localhost services]# rm /etc/my.cnf
```


<!--more-->

### 下载 Mysql 安装包和解压文件

[Mysql 5.5 下载地址](https://dev.mysql.com/downloads/mysql/5.5.html#downloads)，下载 Linux- Generic 64 位 tar.gz 安装包，上传到/usr/services 目录下：
```sh
# 解压
[root@localhost services]# tar  -zxvf  mysql-5.5.61-linux-glibc2.12-x86_64.tar.gz
# 重命名
[root@localhost services]# mv mysql-5.5.61-linux-glibc2.12-x86_64 mysql
```


### 配置和安装
创建mysql用户、用户组：

```sh
# 创建 mysql 用户组
[root@localhost services]# groupadd mysql
# 创建 mysql 用户且用户组为 mysql
[root@localhost services]# useradd -g mysql mysql
```

在 etc 下新建配置文件my.cnf
```sh
[root@localhost services]# cd mysql
[root@localhost mysql]# cp support-files/my-medium.cnf /etc/my.cnf
[root@localhost mysql]# vim /etc/my.cnf
```

在 /etc/my.cnf 最后添加以下两行：
`basedir=/usr/services/mysql`
`datadir=/usr/services/mysql/data`

添加可执行权限：
```sh
[root@localhost mysql]# chown -R mysql:mysql ./
```

安装、初始化数据库:
```sh
[root@localhost mysql]# ./scripts/mysql_install_db --user=mysql --basedir=/usr/services/mysql/ --datadir=/usr/services/mysql/data/
```

修改当前data目录的拥有者为mysql用户:
```sh
[root@localhost mysql]# chown -R mysql:mysql data
```

授予 my.cnf 权限:
```sh
[root@localhost mysql]# chown 755 /etc/my.cnf
```

### 注册服务

复制启动脚本到资源目录:
```sh
[root@localhost mysql]# cp ./support-files/mysql.server /etc/rc.d/init.d/mysqld
# 编辑 /etc/rc.d/init.d/mysqld
[root@localhost mysql]# vim /etc/rc.d/init.d/mysqld
# 找到 basedir 和 datadir，并设置为如下形式：
basedir=/usr/services/mysql
datadir=/usr/services/mysql/data
```

赋予 mysqld 服务脚本可执行权限：
```sh
[root@localhost mysql]# chmod +x /etc/rc.d/init.d/mysqld
```

将 mysqld 服务加入到系统服务，检查mysqld服务是否已经生效：
```sh
[root@localhost mysql]# chkconfig --add mysqld
[root@localhost mysql]# chkconfig --list mysqld
```

将 mysql 的bin目录加入PATH环境变量，编辑 ~/.bash_profile文件：
```sh
[root@localhost mysql]# vim ~/.bash_profile

# 添加如下内容
export PATH=$PATH:/usr/services/mysql/bin
# 使配置文件立即生效
[root@localhost mysql]# source ~/.bash_profile
```

Mysql 服务相关：
```sh
# 启动 Mysql 服务
[root@localhost mysql]# service mysqld start
# 停止 Mysql 服务
[root@localhost mysql]# service mysqld stop
# 查看 Mysql 服务状态
[root@localhost mysql]# service mysqld status
# 重启 Mysql 服务
[root@localhost mysql]# service mysqld restart
```

登录mysql:
```sh
[root@localhost mysql]# mysql -u root -p password
```

允许远程访问:
```sh
mysql> use mysql;
Database changed
mysql> GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
mysql> flush privileges;
```

你也可以单独设置允许访问的 IP 。

### Reference

- [centos7.5离线安装mysql5.5.61](https://blog.csdn.net/qq_35197601/article/details/83542498)