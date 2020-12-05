---
title: 你从未见过的全新版本
comments: true
toc: true
date: 2020-04-18 10:31:00
categories:
  - 博客开发
tags:
  - Kratos
---

你从未见过的全新版本，这一次重新定义本站 (划掉 

<!-- more--> 

在挂着基于 `icarus` 魔改的主题一年之后，我终于下定决心换下一个主题 `Kratos-Rebirth`；静态博客的本质就是换主题 (雾 。在这里非常感谢 [@糖喵🍭同学](https://candinya.com/) 在无数个月黑风高的晚上积极地维护和更新  [Kratos-Rebirth](https://github.com/Candinya/Kratos-Rebirth)，如果你也觉得这个主题很赞，你应该去  https://github.com/Candinya/Kratos-Rebirth 点一个⭐，不要嫌麻烦，这可能是最好的支持方式。

那么，就来看看本次如何重新定义本站的吧 x 

### 全新的面貌

![首页](https://cdn.jsdelivr.net/gh/vensing/static@master/image/agbkYHThGBAdnt4.png)


必须得吹一下，`Kratos-Rebirth` 主题渲染后的页面真的很好看，而且全站采用 pjax 技术做到了类似 vue 单页应用的页面渲染效果，提高了用户访问页面时的体验。

<img src="https://cdn.jsdelivr.net/gh/vensing/static@master/image/5ZeynDRVbHWl6Iv.png" alt="移动端" style="zoom:25%;" />

移动端的颜值和体验也是非常棒 (๑•̀ㅂ•́)و✧，阅读体验也很赞。是不是感觉跃跃欲试了 (搓手.jpg


### disqusjs 基础评论模式

![disqusjs](https://cdn.jsdelivr.net/gh/vensing/static@master/image/NVJDU6rwI5kSGCi.png)

Hexo 等静态博客由于没有后端程序，其留言评论是真的让人很纠结很头大，总结下有以下几种主流方式：

- valine 结合 LeanCloud 
- gitTalk 配合 github
- disqus 和 disqusjs 基础评论模式

以上三种方式都可以 (不做比较)，我比较偏爱 disqus 的评论服务，但难受的就是不开代理评论服务就嗝屁了。对于那些没有代理手段的用户是看不到已有的留言评论的，这一点劝退了很多访客，体验真的不好 ( 我完全没有访客 )  。好在上有政策，下有对策，[disqusjs](https://github.com/SukkaW/DisqusJS) 提出了反向代理的解决方案。


现在，没有开代理的访客也能看到留言评论了，如果第一次加载评论基础模式失败，您需要点击重载才能加载出来；如果您想留下一个评论，您还是需要开代理，因为 disqusjs 仅仅只是拿到评论列表进行展示 (没错，如果你真的想留下评论，开代理吧，我的朋友。这里，着重讲一下，如何利用 CloudFlare 提供的免费 Worker 来代理 disqus 的 API 地址 (白嫖真爽啊。 

#### CF Workers 反向代理

首先，你需要登录到 CloudFlare， 然后找到 Workers ，选择 Free 计划 (土豪请随意选择)；然后你可能需要填一个  **xxxx.workers.dev** 的域名地址，填好之后点击 **创建 Worker**，worker 名字随意但这里建议填 **disqusjs-api**。进入编辑页面，把[官方示例 CF Workers 反代项目](https://github.com/idawnlight/disqusjs-proxy-cloudflare-workers/blob/master/worker.js ) 里的内容复制到左侧脚本框中，弄好之后再点击右侧发起 HTTP GET 请求测试，如果出现 200 OK，那就说明成功了。 

![CF Workers 反向代理](https://cdn.jsdelivr.net/gh/vensing/static@master/image/U9fgABpsERmihkt.png)

#### disqusjs 配置

我的 disqusjs 配置如下：

```yaml
# DisqusJS
disqusjs:
  shortname: your shorname
  sitename: your sitename
  api: https://disqusjs-api.xxxx.workers.dev/api/
  apikey: your disqus public API
  admin: Vexsy
  adminlabel: 风月
```
api 这里得注意下，不是填 https://disqusjs-api.xxxx.workers.dev  而是 https://disqusjs-api.xxxx.workers.dev/api/ ，请在后边加上 /api/ ，因为我们需要代理的是 disqus.com/api/ 。apikey 在https://disqus.com/api/applications/ 页面中可以找到 ，请使用 Public Key !!!

### 更合理的托管方式

由于 Kratos-Rebirth 主题在维护和更新，后续会有新的功能加入所以我们必须得同步更新；直接把主题 Clone 到 Blog 项目的 themes 文件夹下，Github 并不会提交嵌套仓库的文件夹。别问我为啥不用 submodule，我完全不会那东西也不想用 (理直气壮 。所以这次我打算把主题也托管在 github 仓库得了，然后 Travis CI build 在执行 **install** 时 clone 下主题放到 **themes**  文件夹下即可。


#### 主题托管

主题我托管在 [vensing/Kratos-Rebirth](https://github.com/vensing/Kratos-Rebirth)仓库，有两个分支：

- master 同步 Candinya/Kratos-Rebirth 的源码
- custom 放我博客用到的主题代码，包含一些自定义修改和私人配置等

你需要将 Candinya/Kratos-Rebirth 添加为远程源以便同步其更新：

```shell 
# 添加远程源
git remote add upstream https://github.com/Candinya/Kratos-Rebirth
# 拉取
git fetch upstream 
# 融合
git merge upstream/master
```

这样，Candinya/Kratos-Rebirth 库更新了，master 分支同步下，最后在 merge 到 custom 分支即可。由于主题托管在 Github，因此博客根目录下的 themes 文件夹便可以删除了，你需要在 .gitignore 添加配置，忽略该文件夹。最后的主题仓库的分支图大概长这样⬇：

![SourceTree 下的分支结构](https://cdn.jsdelivr.net/gh/vensing/static@master/image/R97WFHiOhSCsyfU.png)

#### Travis CI 配置

由于主题放到了 github 仓库，所以 Travis CI 的配置还得修改下，具体就是在执行 **install** 时 clone 下 vensing/Kratos-Rebirth 库的 custom 分支(这个分支才包含了主题的私人配置项)。只要能保证在执行 *hexo clean && hexo g*  之前把主题 clone 下来即可。

以下是我的Travis CI 配置文件：

```yaml
language: node_js
node_js: 12.14.1 

sudo: false

cache:
  apt: true
  directories:
    - "node_modules"
 
addons:
  ssh_known_hosts:
  - github.com
  - vensing.com

notifications:
  email:
    recipients:
      - xxxx@xmail.com
    on_success: never
    on_failure: never

install:
  - npm install
  - git clone -b custom https://github.com/vensing/Kratos-Rebirth.git themes/Kratos-Rebirth

before_script:
  # 解密 RSA 私钥并设置为本机 ssh 私钥
  - openssl aes-256-cbc -K $encrypted_xxxxxx_key -iv $encrypted_xxxxxx_iv 
    -in travis/travis.key.enc -out ~/.ssh/id_rsa -d
  - chmod 600 ~/.ssh/id_rsa
  - export TZ='Asia/Shanghai'
  - chmod +x _travis.sh

script:
  - hexo clean && hexo g

after_success:
  - rsync -rv --delete -e 'ssh -o stricthostkeychecking=no -p port' public/ root@yoursite:/www

after_script:
  - ./_travis.sh

branches:
  only:
    - source

```

详细的配置文件在 Gist 上：https://gist.github.com/vensing/0296bf555c794d4392c05c75ce00d17c.js

### 一些其他事情

在更换主题时，也遇到了很多问题，比如说：[Kratos-Rebirth #issues-4](https://github.com/Candinya/Kratos-Rebirth/issues/4)；糖喵🍭同学很有耐心的都修复了。当然，咱也不能完全白嫖，于是提了一个简单的 Pull Request：[Kratos-Rebirth #PR-3](https://github.com/Candinya/Kratos-Rebirth/pull/3)，新增 RSS Feed 和修复了表格无样式的问题。

开源确实不是一件容易的事情，所以你应该马不停蹄地给那些好项目点个⭐，或者积极地去参与贡献；而不是一味地要求创作者们解决问题。


最后，庆祝下本站终于换了新面貌。好耶(๑•̀ㅂ•́)و✧

