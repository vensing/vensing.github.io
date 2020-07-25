---
title: Win10 Hyper-V 端口保留问题
comments: true
toc: true
date: 2020-07-25 10:28:35
categories: 编程
tags: Win10
---


WSL2 真香，但是由于 WSL2 需要开启 Hyper-V 功能，最近遇到了运行一些软件时，提示端口已被使用或者端口拒绝连接的错误。导致 1024 ~ 13977 间的一部分端口被 Hyper-V 保留，tomcat、IDEA 等程序跑不起来。

<!-- more -->

### 端口无法使用

![端口拒绝访问](https://i.loli.net/2020/07/25/2EIgscP6wJiz1Ya.png)

如上图所述，使用 hexo 预览博客网页时指定了 8080 端口，但是被拒绝访问端口了。不止 8080 端口，8005、8009 也都直接挂了，导致 tomcat 默认端口配置启动时，提示这些端口早已被使用，无法启动服务。于是，就去查看 8080 端口占用情况：

![8080 端口占用情况](https://i.loli.net/2020/07/25/Irenj9CcJoR6D2s.png)

可以看到内部地址没有查到 8080 端口的进程，图中显示的 8080 端口是外部地址的端口，并不是本地进程使用的端口。所以情况就是：某些程序提示端口拒绝访问或者端口早已被占用，但是使用命令查询端口占用情况时，却发现端口根本没有程序占用过。

迷茫ヽ(*。>Д<)o゜>

搜索了半天「端口未占用 却无法使用」，返回的结果都是：如何查询端口占用，关闭占用端口的进程。我可去特么的吧。偶然间，看到了一条说 Hyper-V 保留端口的回答，而WSL2 又是基于 Hyper-V ，我意识到了事情并没有这么简单 —— 我特么搜索的关键字不对。于是，使用 「Hyper-V 端口占用」搜索，终于看到了一点曙光。

原来是开启 Hyper-V 后，系统会保留一部分端口给 Hyper-V 使用，而 Windows 默认的动态端口的范围是：[1024 ~ 13977]，所以很有可能 8080 等端口被 Hyper-V 保留了。

```sh

    # 查看 Windows tcp 默认动态端口范围
    netsh int ipv4 show dynamicport tcp

    协议 tcp 动态端口范围
    ---------------------------------
    启动端口        : 1024
    端口数          : 13977

    # 查看 Hyper-V 保留的端口
    netsh interface ipv4 show excludedportrange protocol=tcp

    协议 tcp 端口排除范围
    开始端口    结束端口
    ----------    --------
      1026        1125
      1226        1325
      1326        1425
      1426        1525
      1526        1625
      ....        8080
      8081        ....

      ....

```

可以看到 8080 确实被 Hyper-V 保留了...

#### 关于动态端口

动态端口的范围从 1024 到 65535，这些端口号一般不固定分配给某个服务，也就是说许多服务都可以使用这些端口。只要运行的程序向系统提出访问网络的申请，那么系统就可以从这些端口号中分配一个供该程序使用。比如 1024 端口就是分配给第一个向系统发出申请的程序。在关闭程序进程后，就会释放所占用的端口号。

### 解决办法

#### 重启或者重置端口

都说重启能解决 99% 的问题，但是在 Hyper-V 保留端口这种情况下，还是得看人品和运气的；重启会重置端口保留范围，像我就重启了几次都还是端口被保留了(悲 

```sh
    # 重置端口
    netsh winsock reset
```

使用命令重置端口的情况和重启差不多，都是看人品和运气。

#### 修改动态端口范围

1. 关闭 Hyper-V
    - `CMD 管理员`下关闭 Hyper-V
    ```sh
        C:\WINDOWS\system32>dism.exe /Online /Disable-Feature:Microsoft-Hyper-V
    ```
    - 控制面板 --> 程序和功能 --> 启动或关闭 Windows 功能 --> 取消勾选 Hyper-V 
2. 修改动态端口范围
    - `CMD 管理员`下执行如下命令
    ```sh
        C:\WINDOWS\system32>netsh int ipv4 set dynamicport tcp start=49152 num=16383 
        确定。

        C:\WINDOWS\system32>netsh int ipv4 set dynamicport udp start=49152 num=16383 
        确定。

        #或者你也可以排除指定的某个端口，但其他端口可能还是会被保留而无法使用
        netsh int ipv4 add excludedportrange protocol=tcp startport=8080 numberofports=1

    ```
3. 查看端口情况
    ```sh
        C:\Users\vensi>netsh int ipv4 show dynamicport tcp
        协议 tcp 动态端口范围
        ---------------------------------
        启动端口        : 49152
        端口数          : 16383

    ```
4. 开启 Hyper-V 
    - `CMD 管理员`下开启 Hyper-V
    ```sh
        C:\WINDOWS\system32>dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All
    ```
    - 控制面板 --> 程序和功能 --> 启动或关闭 Windows 功能 --> 勾选 Hyper-V 


之后重启电脑就好了，端口又能正常使用了。


### 参考

- [Hyper-V 和 IDEA 运行端口占用问题](https://www.cnblogs.com/eelve/p/12679125.html)
- [Unable to bind ports: Docker-for-Windows & Hyper-V excluding but not using important port ranges #3171](https://github.com/docker/for-win/issues/3171#issuecomment-459205576)


