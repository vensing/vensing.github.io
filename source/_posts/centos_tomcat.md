---
title: Centos7 下安装 Tomcat 8.5
date: 2019-05-28 14:40:30
categories:
 - Linux
tags:
 - 开发环境
 - Tomcat安装
comments: true
toc: true
---

本文仅适用于个人开发学习的环境搭建参考，搭建步骤基于网络教程，因此可能有很多不严谨的地方，目的是做为笔记参考学习使用。

如果你觉得这篇文字像流水账一样无聊又没有看下去的欲望，可以跳过，翻阅我的其他博客文章。

###  下载 Tomcat 离线安装压缩文件

[tomcat 8 下载地址](https://tomcat.apache.org/download-80.cgi)，下载 Core 下的 zip 或者 tar.gz 包都行。


将压缩包上传至 /usr/tmp (其他目录亦可)目录下，提取解压。
```sh
# zip压缩包解压
[root@localhost tmp]# unzip apache-tomcat.8.5.41.zip 

# tar.gz压缩包解压
[root@localhost tmp]# tar -zxvf apache-tomcat.8.5.41.tar.gz 

```

<!--more-->

### 移动文件和测试启动
将 /usr/tmp 目录下解压出来的目录 apache-tomcat.8.5.41 文件夹移动到 /usr/services (没有则创建此目录)目录下：

```sh
# 移动 apache-tomcat 文件夹
[root@localhost tmp]#  mv apache-tomcat.xxx /usr/services
# 进入 apache-tomcat 文件夹下的 bin 目录
[root@localhost tmp]# cd /usr/services/apache-tomcat.8.5.41/bin
# 执行启动脚本，Tomcat started 出现说明启动成功
[root@localhost bin]# ./startup.sh
Using CATALINA_BASE:   /usr/services/apache-tomcat-8.5.41
Using CATALINA_HOME:   /usr/services/apache-tomcat-8.5.41
Using CATALINA_TMPDIR: /usr/services/apache-tomcat-8.5.41/temp
Using JRE_HOME:        /usr/java/jdk1.8.0_202/jre
Using CLASSPATH:       /usr/services/apache-tomcat-8.5.41/bin/bootstrap.jar:/usr/services/apache-tomcat-8.5.41/bin/tomcat-juli.jar
Using CATALINA_PID:    /usr/services/apache-tomcat-8.5.41/tomcat.pid
Tomcat started.

```

可在当前 Centos 系统下的火狐浏览器输入: `localhost:8080`
能访问到 tomcat 的介绍页面即说明启动成功。

### 端口配置

默认安装后的端口是 8080 ，如果需要修改端口号，编辑 apache-tomcat.8.5.41/conf/server.xml :
```sh
# 编辑 server.xml 并将之前的 8080 端口改为 80 
[root@localhost conf]# vim server.xml
```

开放 80 端口（允许远程访问）
```sh
[root@localhost conf]# firewall-cmd --zone=public --add-port=80/tcp --permanent

[root@localhost conf]# firewall-cmd --reload
```

查看开放端口
```sh
[root@localhost conf]# firewall-cmd --zone=public --list-ports
```

关闭端口
```sh
[root@localhost conf]# firewall-cmd --remove-port=8080/tcp –permanent

[root@localhost conf]# firewall-cmd --reload
```

或者你觉得，不怎么在意安全问题，可以把防火墙直接关闭了，就不要搞这么多开放端口号的麻烦事~（反正我是直接把防火墙给关了一了百了）
```sh
# 启动： 
[root@localhost conf]# systemctl start firewalld

# 关闭： 
[root@localhost conf]# systemctl stop firewalld

# 查看状态： 
[root@localhost conf]#  systemctl status firewalld

#开机禁用  ： 
[root@localhost conf]# systemctl disable firewalld

#开机启用  ： 
[root@localhost conf]# systemctl enable firewalld
```

### 注册服务和开机自启动

 **进入 apache-tomcat.8.5.41 安装目录下的 bin 目录：**
```sh
[root@localhost bin]# cd /usr/services/apache-tomcat.8.5.41/bin
# 创建 setenv.sh 文件
[root@localhost bin]# vim setenv.sh
```

**将如下内容粘贴进 setenv.sh 中：**
```sh
#add tomcat pid
CATALINA_PID="$CATALINA_BASE/tomcat.pid"
#add java opts
JAVA_OPTS="-server -XX:PermSize=256M -XX:MaxPermSize=1024m -Xms512M -Xmx1024M -XX:MaxNewSize=256m"
```
保存后退出即可。

**打开 bin/catalina.sh :**
```sh
[root@localhost bin]# vim catalina.sh 

# 在代码（注释之下）的第一行加入:
# JDK （注意此处是你的JAVA_HOME安装位置）
JAVA_HOME=/usr/java/jdk1.8.0_144  
```

**注册系统服务：**
进入/usr/lib/systemd/system
```sh
[root@localhost bin]# cd /usr/lib/systemd/system
# 创建 tomcat.service 文件
[root@localhost system]# vi tomcat.service
```

```sh
[Unit]

Description=Tomcat

After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]

Type=forking

# （注意需把/tomcat改为tomcat的绝对安装目录）
PIDFile=/tomcat_dir/tomcat.pid    

# （注意需把/tomcat改为tomcat的绝对安装目录）
ExecStart=/tomcat_dir/bin/startup.sh

ExecReload=/bin/kill -s HUP $MAINPID

ExecStop=/bin/kill -s QUIT $MAINPID

PrivateTmp=true

[Install]

WantedBy=multi-user.target
```


**管理服务：**

- systemctl start tomcat   启动tomcat服务

- systemctl stop tomcat   停止tomcat服务

- systemctl restart tomcat  重启tomcat服务

- systemctl enable tomcat  开机启动

### Reference

- [CentOS7安装Tomcat](https://www.cnblogs.com/yangxiansen/p/7860003.html)


