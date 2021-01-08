---
title:  🎨 hexo-theme-imaimo
date: 2019-07-09 23:00:30
categories:
 - 瞎折腾
tags:
 - hexo主题
comments: true
toc: true
hidden: true
---


**hexo-theme-imaimo** 👇 是某天心血来潮的产物，目前还很简陋。

- 📁 项目地址：[hexo-theme-imaimo](https://github.com/vensing/hexo-theme-imaimo)
<!--more-->
- 🎨 一个移植的主题，样式有些传统，但很简洁和实用。
- 🚀 仅为个人兴趣驱使，理论上只有我或者觉得它好看的人使用。



![hexo-imaimo.png](https://cdn.jsdelivr.net/gh/vensing/static@master/image/5d10a59f842d945783.png)


### 📝 来源

本主题基于 [http://acgtofe.com/](http://acgtofe.com/) ACGTOFE 站点主题移植，主题的所有权归原作者所有，目前正在努力与原作者联系主题授权中。



### 🎯 功能

本主题基于 Hexo 默认主题 `landscape ` 框架构建，将 `ACGTOFE` 的主题移植到 Hexo 平台。实现的功能基本和 landscape 一致，基础的主题功能已大致成形。基本功能如下：

- ✅ 首页
- ✅ 归档页
- ✅ 分类页
- ✅ widget小部件(分类)
- ✅ 分页
- ✅ 图片预览(fancybox.js)
- ✅ 代码高亮(highlight.js 需完善)
- ✅ 其他


### 🔨 使用

现在还是测试版，有很多功能缺少和未修复的 bug，因此不建议直接拿来做为线上博客使用。

基本使用方式是将本项目拉下来放到你博客目录下的 theme 目录下，将博客配置文件`_config.yml` 中的`theme`属性设置为本主题。

执行 `hexo clean && hexo g` 和 `hexo s` 预览。

### ⚠ 注意事项

**0x01** 

使用 `highlight.js` 代码高亮，需先将博客主题配置文件`_config.yml`做如下配置:

```yaml
highlight:
  enable: false
  line_number: false
  auto_detect: false
  tab_replace:
```

**0x02** 

首页上方导航栏如何自定义菜单项？

例如：新增一个`About`导航菜单栏。

1.在主题配置文件`_config.yml`下做如下配置：

```yaml
# Header
menu:
  Home: /
  Archives: /archives
  About: /about
  Links: /friends
```

2.需在博客根目录下的`source`文件夹下新建一个名为`about`的文件夹，再新建一个`index.md`即可 (最终路径：`/blogpath/source/about/index.md`)。index.md 和普通文章 md 文件一样编写即可；新增菜单项的 url 和 source 文件夹下新建目录名应一致。

### 📌 后期计划

- 🔀 评论功能
- 🔀 更多的 widget 小部件
- 🔀 文章 toc 目录
- 🔀 文章阅读量
- 🔀 文章过期提醒 (超过xxx天，在文章详细页标题下显示一个警告框，类似 v2ex )
- 🔀 代码优化 (目前代码乱七八糟的)
- 🔀 解决未知 bug
- 🔀 其他


因博主要上班摸鱼划水，所以更新比较随意甚至可能十天半个月没有更新，总之有时间再弄🧑。

Enjoy it !  Build with <span style="color:red;font-family:Arial;font-size:14px">❤</span> by Vexsy.