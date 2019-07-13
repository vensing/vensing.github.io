---
title: Centos7 下安装 Redis 3.2.10 
date: 2019-05-28 15:18:39
categories:
 - 技术
tags:
 - 开发环境
 - Redis
comments: true
toc: true
---
本文仅适用于个人开发学习的环境搭建参考，搭建步骤基于网络教程，因此可能有很多不严谨的地方，目的是做为笔记参考学习使用。

如果你觉得这篇文字像流水账一样无聊又没有看下去的欲望，可以跳过，翻阅我的其他博客文章。

### 依赖环境
- gcc-c++

这个需先安装好，这里就不展开如何安装了。

### 下载 Redis 3.2.10 tar.gz 安装包

[Redis 安装包下载地址](http://download.redis.io/releases/) 或者你也可以去 Github 上 [Redis](https://github.com/antirez/redis) 的官方仓库下的 [Releases](https://github.com/antirez/redis/releases) 页面下载，这个随你开心就好啦。
<!--more-->
### 解压和编译安装

**准备Redis安装文件：**

下载redis-3.2.10.tar.gz上传到`/usr/services`文件夹下

**解压redis：**
```sh
[root@localhost services]# tar -zxvf redis-3.2.10.tar.gz
```

**执行安装：**
```sh
# 进入解压后的文件夹：
[root@localhost services]# cd /usr/services/redis-3.2.10
```

**编译安装到指定文件夹：**
```sh
[root@localhost redis-3.2.10]# make install 
```

### 测试启动

**进入 install/bin 目录下：**

```sh
[root@localhost redis-3.2.10]# cd src
# 执行启动脚本
[root@localhost bin]# ./redis-server
...
...
...
The server is now ready to accept connections on port 6379
```

**新开一个终端：**
```sh
[root@localhost redis-3.2.10]# cd /usr/services/redis-3.2.10/src
[root@localhost src]# ./redis-cli
127.0.0.1:6379> ping
PONG
127.0.0.1:6379> 
```
如果能ping通这说明安装并且启动成功啦。

### 配置文件

**复制配置文件：**
```sh
[root@localhost redis-3.2.10]# cp /usr/services/redis-3.2.10/redis.conf /usr/services/redis-3.2.10/src/bin/
```

**修改配置文件：**
```sh
[root@localhost redis-3.2.10]# cd src/bin/
[root@localhost bin]# vim redis.conf
```

- 允许远程连接：bind 0.0.0.0
- 移除保护模式：protected-mode no
- 允许后台运行：daemonize yes
- 设置密码：requirepass 密码

**指定配置文件启动 redis server：**
```sh
[root@localhost src]# ./redis-server bin/redis.conf
```

**注：** 如果不指定配置文件的话，执行默认启动，配置文件中的修改没用到也就不会生效了(远程访问就无法成功连接了)。

在 Windows 下启动 redis-cli，cmd 下进入 windows 下的 Redis 安装目录：
```sh
redis-cli -h ip -p port -a password
192.168.199.130:6379> ping
PONG
```

### 注册服务

**编辑文件：**
```sh
[root@localhost redis-3.2.10]# vim /etc/systemd/system/redis-server.service
```


复制以下内容到redis-server.service：

```sh
[Unit]

Description=The redis-server Process Manager

After=syslog.target

After=network.target

[Service]

Type=forking

ExecStart=/usr/services/redis-3.2.10/src/redis-server /usr/services/redis-3.2.10/src/bin/redis.conf        

ExecReload=/bin/kill -USR2 $MAINPID

ExecStop=/bin/kill -SIGINT $MAINPID

Restart=always

PrivateTmp=true

[Install]

WantedBy=multi-user.target
```


- systemctl daemon-reload 刷新所有服务项
- systemctl start redis-server.service 开启服务
- systemctl stop redis-server.service 关闭服务
- systemctl status redis-server.service 查看服务状态
- systemctl restart redis-server.service 重启服务
- systemctl enable redis-server.service  开机启动

**配置防火墙**

如果闲配置麻烦又不在乎安全问题，可以直接把防火墙关了。

启动防火墙：
- systemctl start firewalld

将6379端口添加到防火墙例外并重启：

- firewall-cmd --zone=public --add-port=6379/tcp --permanent

- firewall-cmd -reload



### Reference

- [CentOS7.6离线安装Redis5.0.4](https://www.cnblogs.com/xu-qian-gang/p/10671764.html)