---
title: 使用 Travis CI 自动部署到 Github Pages 和 VPS
date: 2019-04-07 13:30:00
categories:
  - 自动部署
  - Travis CI
tags:
  - 自动部署
  - Travis CI
toc: true
---

是的，都 2019 年了我还在写自动部署这样的文章。

基于之前的文章 [使用Travis CI持续部署Hexo博客](https://vensing.com/2019/01/25/Travis-CI/) 做一个补充。本次除了自动部署到 Github  Pages 上还部署到 VPS 服务器上。

原因说简单点就是：我不想每次本地写完点东西后，还得手动生成静态页面，然后再利用 xshell 这样的工具把静态页面上传到我的 VPS 服务器上。这简直不要太麻烦，我想写完东西之后通过 Git push 到仓库之后，自动去部署到 Github Pages 也好还是 VPS 也好。总之不用我瞎操作一顿了，我的原则是博客越轻量越简洁好。

基于这样的原则，花了点时间搞了下自动部署到 VPS 上。

之前用 Travis CI  自动部署用的是 GitHub 的 Personal access tokens，配合 Travis 的环境变量配置就可以 push 操作了。这个 token 是可以拿到你 github 上所有仓库操作权限的，所以这次我打算不用这个 token 了，直接搞个部署密钥更加安全。

<!-- more -->

> ### 生成部署私钥

首先是先生成 ssh 密钥，在你电脑上随便哪个文件夹都行：

```git
ssh-keygen -f travis.key 
```

把生成的 travis.key.pub 里的内容粘到你 Github 仓库的 Deploy Keys 以及 VPS 上的 `~/.ssh/authorized_keys` 里。这样 Travis CI 就能对 Github 和 VPS 进行访问了。


> ### 加密私钥

Travis CI 自动部署时，我们必须从仓库拿到这个密钥（之前的 token 是 设置了环境变量）。直接把密钥放仓库下肯定是不安全的，Travis 提供了密钥加密解密的方法。

首先，在 Linux 环境下安装 Travis 命令行工具 ，需先[安装 ruby 环境](http://www.ruby-lang.org/zh_cn/documentation/installation/)：

```sh
# 我的VPS装的是ubuntu,ubuntu安装ruby环境
$ sudo apt-get install ruby-full
# 安装Travis命令行工具
$ sudo gem install travis
```

加密密钥文件：

```sh
# 交互式操作，使用 GitHub 账号密码登录  
# 如果是私有项目要加个 --pro 参数 
$ travis login --auto 

# 加密完成后会在当前目录下(确保travis.key文件在此目录下)生成一个 travis.key.enc 文件  
$ travis encrypt-file -r XXX/XXX.github.io travis.key -add
```




> ### .travis.yml 配置

解密密钥文件：
将 travis.key.enc 放到仓库下，哪个位置随你喜欢，确保解密命令能访问到就成。`$encrypted_383bc2ea2d21_key`及`$encrypted_383bc2ea2d21_iv` 请去travis ci仓库设置环境变量里找(Travis 会自动生成这两个环境变量)。在 .travis.yml 下添加如下命令：

```sh
before_script:
  # 解密 RSA 私钥并设置为本机 ssh 私钥
  - openssl aes-256-cbc -K $encrypted_383bc2ea2d21_key -iv $encrypted_383bc2ea2d21_iv 
    -in travis/travis.key.enc -out ~/.ssh/id_rsa -d
  - chmod 600 ~/.ssh/id_rsa
```


为了防止出现 ssh 登录要输入连接确认（总不至于在 travis ci 自动部署时去travis命令行确认下？），需在 .travis.yml 添加一个 ssh 信任列表（怎么简单怎么来）：

```sh
addons:
  ssh_known_hosts:
  - github.com
  - vensing.com
```

那么，Travis CI 自动构建成功后怎么部署到 VPS 上呢？在 .travis.yml 中添加如下命令（这种方式暴露了端口号...但好像没别的好办法）：

```sh
after_success:
# public 后面加上/即可将该目录下的文件都传送到服务器了
  - rsync -rv --delete -e 'ssh -o stricthostkeychecking=no -p 端口号' public/ 用户@域名:/路径
```


配置文件放 [Gist](https://gist.github.com/vensing/0296bf555c794d4392c05c75ce00d17c) 上，仅供参考。

> ### Logo

换了个 Logo，自己用 PS 做的，有点借鉴（~~抄袭~~ ）[PRIN](https://blessing.studio) 的灵感。
![](/images/logo.png)

> ### 参考链接

主要是参考第一篇文章 ([PRIN](https://blessing.studio) 原创) 折腾的 ┏ (゜ω゜)=☞。

- [使用 Travis CI 自动部署 Hexo 博客](https://blessing.studio/deploy-hexo-blog-automatically-with-travis-ci/)
- [使用 Travis 自动部署 Hexo 到 Github 与 自己的服务器](https://segmentfault.com/a/1190000009054888)
