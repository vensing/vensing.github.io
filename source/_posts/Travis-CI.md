---
title: 使用 Travis CI 自动部署 Hexo 博客
categories:
  - 技术
tags:
  - 自动部署
  - Travis CI
type: tags
abbrlink: 2331
date: 2019-01-25 22:37:06
toc: true
---

是时候使用 Travis CI 自动部署 Hexo 博客啦。

<!--more-->

![Travis CI 自动部署流程](https://i.loli.net/2019/07/13/5d29679d61e4094268.png)


## 没有 Travis CI 之前

在没有 Travis CI 之前，写一篇 Hexo 博客文章再推送到 GitHub Pages 上的流程是：

1.本地新建一篇文章：
```
 $ hexo new [layout] <title>
```
2.用markdown语法编辑文章

3.本地生成 public 文件：
```
$ hexo clean && hexo g 
```
4.在本地启动服务器测试：
```
$ hexo s 
```
5.浏览器打开`http://localhost:4000/`，查看效果并调试

6.调试好之后，执行部署命令部署到 Github Pages 上：
```
$ hexo d
```


## 使用 Travis CI 持续部署后

Travis CI 一款很好用的持续集成测试工具。它可以自动关联Github上的项目并且clone下来编译测试，就是利用它这一特性来实现hexo博客自动编译、部署。

在使用 Travis CI 之后，就只需要写好博客文章之后将 Hexo 博客项目通过 以下 Git 命令推送到 Github Pages 的源码分支 (source分支) 即可。

```
$ git add .

$ git commit -m "your message"

$ git push -u origin source:source
```


而后 Travis CI 监听到 push 操作即会根据 travis.yml 执行自动部署，原理简单说来就是先 git clone 线上 GitHub Pages 项目的源码分支 (source分支) ，再执行自动部署后将 Hexo 博客的静态页面推送到 GitHub Pages 项目的 master 分支。

## Why we need Travis CI?

**使用Travis CI 自动部署的好处**

有人可能会有疑问: 在本地写完博客，直接一个命令`hexo d`，不就搞定了么， 为啥要费力搞 CI ？

的确，想用 TravisCI 来自动部署Hexo博客程序，需要不少设置（瞎折腾），但其还是有很多实用之处，列举一些优点：

**优点1：直接在线编辑文件，立即生效**

假设你已经发表了一篇文章，过了几天你在朋友机器上浏览发现有几个明显的错别字，对于有强迫症的，这是不能容忍的。 但你手头又没有完整的hexo+nodejs+git的开发环境，重新下载git，node，hexo配置会花费不少时间，特别不划算。

如果按照这篇完整折腾完，你可以直接用浏览器访问github个人项目仓库，直接编辑那篇post的原md文件，前后2分钟改完。 稍等片刻，你的博客就自动更新了。

**优点2：自动部署，同时部署到多个地方**

在gitcafe是被收购之前，很多同学（包括我）都是托管在上面的，国内访问速度比Github快很多。

配合DNS根据IP位置可以自动选择导到gitcafe, 还是github，甚至你还可以部署到七牛云的静态网站。

利用Travis CI可同时更新多个仓库。

**优点3：部署快捷方便**

手动deploy需要推送public整个folder到github上，当后期网站文章、图片较多时候，对于天朝的网络，有时候连接github 就是不顺畅，经常要傻等不少上传时间。

有了CI，你可以只提交post文件里单独的md文件即可，很快很爽，谁用谁知道。

**优点4：bigger than bigger.**

你的项目Readme里面可以显示 CI build 图标 [![Build Status](https://www.travis-ci.org/vensing/vensing.github.io.svg?branch=source)](https://www.travis-ci.org/vensing/vensing.github.io) ，很酷有没有？

另外通过设置，可以在当build失败时自动发邮件提醒你。

上面的图标，如果登陆后你在Github项目里，直接点击图标，会跳转到你当前项目build的log界面，很方便。

当然有了CI，你可以做很多事情，如自动运行单元测试，成功后再deploy等等。很多项目里的持续集成基本也是这个道理。

## How to use Travis CI to deploy hexo blog?

1.一个仓库两个分支

在 Github Pages 项目下新建一个 source 分支用来存放 Hexo 博客的源码，master 分支则是部署之后生成的静态页面文件。

2.设置 Github Pages 的默认分支  

仓库的 settings 中开启 Github Pages ，选择 master 为默认分支。其实默认的就是 master 分支了。

3.自定义域名

域名注册有很多种服务商供你选择。在 Github Pages 项目的 Setting 页面设置 Custom domain 为你购买的域名。Hexo 项目的主题文件夹的 source 文件夹下添加名为`CNAME` 的文件，注意全部大写，里面内容就写你的自定义域名。如果没有这个文件，每次推送自定义域名都会回到初始的 username.github.io。

4.Travis
在官网使用github账号授权登录，hexo添加配置文件就可以了。
- 获取 Personal access tokens，Github Pages setting --> Developern settings --> Personal access tokens ，点击 Generate new  token 选择仓库权限就可以，新生成一个Token，Travis 环境配置里会用到这个Token。生成之后一定要保存好，因为只会出现一次，丢失了就只能再重新生成了。
![](https://i.loli.net/2019/07/13/5d29685bb712822904.png)
- 登录[官网](https://www.travis-ci.org/)，使用github账号登录。
- 添加 Github Pages 博客仓库。
- 设置选项，这里我只设置 push 代码到 GitHub Pages 时自动部署。右上角 More options 调出Setting页面。
![](https://i.loli.net/2019/07/13/5d296880361a431439.png)
- 在 Travis 的 Settoiing 页面设置环境变量，Name 为“GH_Token”，value 为刚才复制的Token ，然后点击右边的 Add 按钮添加即可。
![](https://i.loli.net/2019/07/13/5d2968974a36f41842.png)
- 在hexo博客源码中添加配置文件`.travis.yml`
需要修改的是git的配置信息。
*要使用https协议的仓库地址，使用ssh仓库地址会失败。*
注意这一行`git push --force --quiet "https://${GH_Token}@${GH_REF}"` 中的GH_Token即为上面Travis设置的环境变量的 Name 。

下面是我的 travis.yml 和 travis.sh 脚本：


```yml
#travis.yml
language: node_js
node_js: stable 

sudo: false

#cache
cache:
  apt: true
  directories:
    - "node_modules"

notifications:
  email:
    recipients:
      - vensing@foxmail.com
    on_success: never
    on_failure: never

# S: Build Lifecycle
install:
  - npm install
  - npm install less@2.7.3 --save-dev
#  - gem install travis
#  - travis login --pro --github-token ${GH_TOKEN}

before_script:
  - export TZ='Asia/Shanghai'
  - npm install -g gulp
  - chmod +x _travis.sh

script:
  - hexo clean && hexo g
  - gulp

after_success:
 # - LAST_BUILD_NUMBER=68
 # - for i in $(seq 1 $LAST_BUILD_NUMBER ); do  travis logs $i --delete --force ; done

after_script:
  - ./_travis.sh

# E: Build LifeCycle

branches:
  only:
    - source
env:
 global:
   - GH_REF: github.com/vensing/vensing.github.io.git
```

注：
1. notifications 可以设置部署成功和失败时自动给你发送邮件，这个功能真的很 nice 。
2. 因为用到了gulp压缩，Travis 自动部署时总是在执行 gulp 命令报错 “less version 3.9.0 is not currently supported”，谷歌一下将 less 版本设置低一点即可，在 install 下加入`- npm install less@2.7.3 --save-dev`。
3. branches 是你Github Pages 项目中存放博客源码的分支，这里是 source 分支，对应上即可。
4. env 下设置 GH_REF ，即设置 Github Pages 的仓库地址，记得是以 .git 结尾的地址。

```sh
#travis.sh

#--------------------------------------------
#!/bin/bash
# slogan：梦想还是要有的，万一实现了呢。
#--------------------------------------------

#定义时间
time=`date +%Y-%m-%d\ %H:%M:%S`

#执行成功
function success(){
   echo "success"
}

#执行失败
function failure(){
   echo "failure"
}

#默认执行
function default(){

  git clone https://${GH_REF} .deploy_git
  cd .deploy_git

  git checkout master
  cd ../

  mv .deploy_git/.git/ ./public/
  cd ./public

cat <<EOF >> README.md
部署状态 | 集成结果 | 参考值
---|---|---
完成时间 | $time | yyyy-mm-dd hh:mm:ss
部署环境 | $TRAVIS_OS_NAME + $TRAVIS_NODE_VERSION | window \| linux + stable
部署类型 | $TRAVIS_EVENT_TYPE | push \| pull_request \| api \| cron
启用Sudo | $TRAVIS_SUDO | false \| true
仓库地址 | $TRAVIS_REPO_SLUG | owner_name/repo_name
提交分支 | $TRAVIS_COMMIT | hash 16位
提交信息 | $TRAVIS_COMMIT_MESSAGE |
Job ID   | $TRAVIS_JOB_ID |
Job NUM  | $TRAVIS_JOB_NUMBER |
EOF

  git init
  git config user.name "vensing"
  git config user.email "782176881@qq.com"
  git add .
  git commit -m "Update Blog By TravisCI With Build $TRAVIS_BUILD_NUMBER"
  # Github Pages
  git push --force --quiet "https://${GH_Token}@${GH_REF}" master:master
  
  # Create Tag
  git tag v1.2.$TRAVIS_BUILD_NUMBER -a -m "Auto Taged By TravisCI With Build $TRAVIS_BUILD_NUMBER"
  # Github Pages
  git push --quiet "https://${GH_Token}@${GH_REF}" master:master --tags

}

case $1 in
    "success")
	     success
       ;;
    "failure")
	     failure
	     ;;
	         *)
       default
esac


```

注：
1. travis.sh 中的 “GH_Token” 也是 travis 环境变量中设置的 Name 。
2. travis.sh 中的 “GH_REF” 为 travis.yml 中设置的仓库地址。

5.测试

配置完成后，写好博客文章之后将 Hexo 博客项目通过 以下 Git 命令推送到 Github Pages 的源码分支 (source分支) 即可。

```
$ git add .

$ git commit -m "your message"

$ git push -u origin master:source
```

然后 ，在登录的 Travis 官网上就能看到自动部署时生成的日志信息了。

## 参考

本文部分内容参考自：[karlzhou](https://www.karlzhou.com)的博文 -- [用Travis CI自动部署Hexo博客](https://www.karlzhou.com/2016/05/28/travis-ci-deploy-blog/)，感谢作者提供的教程和参考。