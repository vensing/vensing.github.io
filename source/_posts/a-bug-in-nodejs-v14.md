---
title: hexo在Node.js v14.0下构建空html的问题
comments: true
toc: true
date: 2020-04-23 09:25:00
categories:
  - 博客开发
tags:
  - hexo
  - nodejs
---

记录下 hexo 在 Node.js v14.0 下构建空 html 的问题。

<!-- more--> 


### Travis CI 构建出错 

昨天推特上有推友在问 Travis CI 构建 hexo 博客静态网页时构建空 html 页面的问题，她说遇到了从未见到过的报错信息。于是我就 Bing 搜索了下报错部分的关键词：

```js
 Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency
```

Bing 还是比较靠谱的，第二个搜索结果就给出了与报错内容问题类似的一个 mongodb 论坛网页。https://jira.mongodb.org/browse/NODE-2536 然后我就点进去看了下，他使用的 Node.js 版本是 v14.0-rc，下面有人回复说也在  v14.0 下遇到了同样的问题。好像有点石锤是 Node.js v14.0 的锅，v14.0 是前几天(21号)发布的最新特性版本 (LTS不香吗 。于是我就回复推油说可能是 Node.js v14.0 的锅，后面她指定了下版本就正常了。我就跑去看了下她的 Travis CI 构建历史，配置文件里写的环境是  nodejs ，版本配置的是 stable，也就是最新的稳定版本。然后 log 信息显示安装的 node 环境是 v14.0，看来问题石锤了 ( stable NO! 。所以别用什么最新版本，害，官网不是说得明明白白推荐大多数人使用 LTS 版本吗？

### 重现 bug

真理来源于实践，于是我决定亲自去重现下这个 bug 。由于我用的是 Nodejs v12.14.1，重现 bug 需要 v14.0 但是我后边又不需要这个版本。所以我需要一个可以切换 Nodejs 版本的工具，重现完bug就滚回 v12.14.1。python 下有 Anaconda 管理版本，Nodejs 也有 nvm(Node version manager) 做版本管理。怎么安装 nvm，你去搜呀。下图是我安装 v14.0.0 步骤的截图：

![nvm 安装 v14.0.0](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Ivlx1KRnF5ypm4A.png)

```shell
# 安装 v14.0
nvm install v14.0
# 列出安装的 nodejs 环境
nvm list 
  14.0.0
* 12.14.1 (Currently using 64-bit executable)
# 使用 v14.0.0
nvm use v14.0.0
```

然后就是执行 hexo clean && hexo g 来测试下是否能正常构建了。果然，出现了那个诡异的 bug，石锤了是 Nodejs v14.0 的锅。

![v14.0.0 构建空 html 的 bug](https://cdn.jsdelivr.net/gh/vensing/static@master/image/sEXuSvawA5rLFJl.png)

### 解决方式

解决方式当然是别用 v14.0.0 最新版本了，hexo 还没做兼容，吓得我赶紧把 Travis CI 配置文件里的 Nodejs 版本指定下，别再用` stable`了它会自动使用最新的稳定版本！

### 总结

不要轻易切换到最新版本，请使用 LTS 长期支持版本，Travis CI 构建时指定具体的 Nodejs 版本，不要图省事填`stable`，它会自动安装最新的 Nodejs 版本。

### 后续

后面将此 Bug 提交到了 [hexo#issue-4257](https://github.com/hexojs/hexo/issues/4257)，后边也有人重现了同样的错误，见[hexo#issue-4260](https://github.com/hexojs/hexo/issues/4260)；以及有人反应在 Nodejs v14 出了同样的问题 [hexo#issue-4263](https://github.com/hexojs/hexo/issues/4263)，官方维护团队的建议是用低版本的 Nodejs 以避免此类错误的发生。而上面报的警告(Warning: Accessing non-existent property 'lineno' of module exports inside circular dependency)是因为在 Nodejs v14 下引用 `stylus` 时出了问题。警告的复现在 [issuecomment-618857837](https://github.com/hexojs/hexo/issues/4257#issuecomment-618857837) 提出，具体复现情况见下图：

![stylus warning 警告](https://cdn.jsdelivr.net/gh/vensing/static@master/image/lTWGwo59CidzSVM.png)

而执行 hexo g 构建空 html 的问题则是因为 Nodejs v14 下使用了严格的参数类型检测，从而导致 `hexo-fs` 的 fs.promises.copyFile 方法在 Nodejs v14 以下版本正常构建，而在 v14 版本上则出现了问题。具体的解释请查看 [hexo-fs#pull-59](https://github.com/hexojs/hexo-fs/pull/59)，`hexo-fs` 涉及到 `hexo-cli` 及 hexo 构建静态网页从而导致构建出了空的 html，详情见评论 [issuecomment-618815265](https://github.com/hexojs/hexo/issues/4260#issuecomment-618815265)。此问题已在 `hexo-fs` [hexo-fs#pull-60](https://github.com/hexojs/hexo-fs/pull/60) 修复。


