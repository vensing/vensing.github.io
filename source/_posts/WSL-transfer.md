---
title: WSL 发行版迁移记录
comments: true
toc: true
date: 2020-10-09 16:58:47
categories:
 - 瞎折腾
tags:
 - WSL
---

使用 WSL2 也有一段时间了，基本上可以告别占用大量资源和操作不便的虚拟机，但是 WSL 发行版和 Docker backend 默认的存储路径在 C 盘就很操蛋，一不小心就给你塞满了，对我这种强迫症患者来说非常难受。

<!-- more -->

### 背景

C 盘塞满和手机电量不足这事很相似，就像看着手机电量不足就想充满电不然没安全感，所以捣鼓了下 WSL 发行版从 C 盘迁移到其他盘上。 我用 WSL 发行版是 Ubuntu 18.04，另外 Docker Desktop For Windows 的 backend 后端守护进程也是跑在 WSL 上，光这两个就占用十几个 G 的空间了(C 盘危。使用 ` wsl --list ` 查看已安装的 WSL 发行版：

```sh
C:\Users\vensi>wsl --list
适用于 Linux 的 Windows 子系统分发版:
Ubuntu-18.04 (默认)
docker-desktop-data
docker-desktop
```

可以看到机器上安装的 Ubuntu 发行版和 Docker 的 backend 后端守护进程，目标就是将它们迁移到其他盘。查看 ` wsl --help ` 可以看到 wsl 提供了 ` --export ` 和 ` --import ` 发行版的导入导出功能，更为方便的是 Github 上有一个项目管理 WSL 的全功能实用程序 [LxRunOffline](https://github.com/DDoSolitary/LxRunOffline) ，我选择使用这个更为强大的工具来管理 WSL。

### 安装 LxRunOffline

你可以去 [LxRunOffline releases](https://github.com/DDoSolitary/LxRunOffline/releases) 页面下载软件包安装，也可以使用 Windows 下的包管理器安装：

```sh
> scoop bucket add extras

> scoop install lxrunoffline
```

这里我使用 scoop 安装，使用 ` scoop list ` 查看已安装的包：


![](https://i.loli.net/2020/10/09/qZNLIMQdRPc4TBt.png)

### 迁移 WSL 发行版

迁移之前，先执行下 ` wsl --shutdown ` 立即终止所有正在运行的分发和 WSL 2 轻型工具虚拟机，退出 Docker Desktop。查看已安装的 WSL 发行版：

```sh
> wsl --list 

# 或者
> LxRunOffline l
```

接着将 Ubuntu 和 Docker backend 迁移到指定盘的目录下，开始迁移：

```sh
# 迁移 Ubuntu
> LxRunOffline m -n Ubuntu-18.04 -d D:\WSL\Ubuntu

# 查看迁移之后的位置
> LxRunOffline di -n Ubuntu-18.04
D:\WSL\Ubuntu

# 迁移 Docker backend
> LxRunOffline m -n docker-desktop-data -d D:\WSL\docker-desktop-data
> LxRunOffline m -n docker-desktop -d D:\WSL\docker-desktop

# 查看迁移之后的位置
> LxRunOffline di -n docker-desktop-data
> LxRunOffline di -n docker-desktop
```

打开 Windows Terminal 进入 WSL Ubuntu-18.04，成功进入终端。打开 Docker Desktop，执行 Docker 相关的命令查看是否能正常运行：

![](https://i.loli.net/2020/10/09/KEosPLMJRIiYglc.png)

浏览器访问 localhost 即可看到 Nginx 默认页面，迁移完毕，功能正常！

使用 LxRunOffline 还可以安装自定义发行版，以及备份/恢复、运行 WSL 发行版等功能，具体请自行探索吧 ~

### 参考

- [想安装更多 Linux 发行版？LxRunOffline 让 WSL 更好用](https://sspai.com/post/61634)