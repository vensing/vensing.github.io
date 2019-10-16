---
title: 一些小小的改变
comments: true
toc: true
date: 2019-07-13 15:56:50
categories:
- 博客
tags:
- 日常
- 更新 
---

简单来说，就是摸鱼划水太舒服了，导致鸽了几个月。

从5月份开始陆续添加了许多友链，到现在已有九个友链 (可喜可贺(๑•̀ㅂ•́)و✧)  。每次收到友链申请的邮件都会在心里窃喜一番，然后郑重其事的给与回复。因为现在玩博客的要么是学生(各个阶段的学生都有，挺魔幻的🤼‍♀️)，要么是在做 IT 工作的大佬，基本上都是和开发沾点边的。

至于建博客的初衷，我也早就忘得一干二净，不然我也不会鸽了好几个月。翻了下真正意义上的第一篇文章 [你能从这里收获什么](https://vensing.com/2018/09/08/the-start/#%E4%BD%A0%E8%83%BD%E4%BB%8E%E8%BF%99%E9%87%8C%E6%94%B6%E8%8E%B7%E4%BB%80%E4%B9%88%EF%BC%9F)，才发现我好像跑偏了，基本上没写啥Java 或者 GIS 开发的东西，反而发表了一大堆乱七八糟且水得不行的文章。

### 折腾了些东西

虽然和最初的理念有点搭不上边，但是也学到了很多前端的东西（各种布局和样式、调试技巧），与其说是前端倒不如说是  hexo 博客和 node.js。前端水太深，技术迭代屌快，前端模块化、工程化这里按下不表我也不会。总得说来，就是我对前端还挺感兴趣的，说不定哪天就转前端了呢 : ) 

话说回来，现在工作是做 Java 后台的，但是其实前端、后台都要写，甚至有时候还得做下部署，只能说是太真实了😂。基本上就是 **「广而不深」、「杂而不精」** 这么一种状态，空有一身武艺但学艺不精。有空再写篇博客文章吐槽下。

<img style="width: 50%;" src="https://i.loli.net/2019/07/13/5d29a6b09ef9e29933.png" />

鸽是鸽了挺久的，于是最近决定痛改前非、改过自新好好地做一个敬业博主。虽说现在个人博客已经是日薄西山，但比起『简书』那种只管内容产出的平台(或是类似的平台)，个人博客还是有更多的自由性和个性化优势。一个惨痛的例子就是百度贴吧在未通知和经过用户允许就删了2017年之前的帖子，能够自主控制和有备份的仓库(如Github) 这也是我觉得个人博客非常 nice 的一个地方，轻量又不缺乏自主性。说了这么多，本次到底弄了些什么东西呢？

<!--more-->

### 图床

图床按照维基百科的释义是：【网络相册，或叫在线相册，为运行、储存以及翻阅、分享于互联网的相册，由于在线相册不是实质的相册并且容易搜索、查阅以及保管，当前大部分照片为储存于在线相册中。】

好吧，你说的都对。基本上就是一个帮我们存放图片的一个平台，引用的时候添加其外链即可。那么，为什么博客要使用图床呢？

<img style="width: 50%;" src="https://i.loli.net/2019/07/13/5d29a6b1440d431154.jpg" />

- 控制反转，图片的管理交给别人，自己不用瞎操心；
- 不会占用服务器存储空间，且一般有 CDN 加速，访问速度有保证；
- 写 md 时，若是引入本地图片，不能在编辑器中加载出来必须得启动服务器才能加载 (因为hexo source 资源文件的机制)；
- 不用上传图片到 Github，加快了 push 速度；
- 能白嫖为什么不白嫖呢 ；
- 以及各种你能想到的理由。

图床图片管理器我使用的是 [PicGo](https://github.com/Molunerfinn/PicGo)，支持多种图床源和上传相册的管理，以及各种好用的特性。本来打算新建一个 Github 仓库当图床的，后来发现图片无法正常访问（可能我是私有仓库的原因），加载也不快就只好不作考虑了。

于是我最终选择了名声在外的 [sm.ms](https://sm.ms/) 。上传图片时可能会出现无法上传的错误，改下图片名基本就能上传了。加载的速度也挺满意的，加载大文件图片比我那阿里云的小水管快些。

![](https://i.loli.net/2019/07/13/5d29a267df82056961.png)

总之，使用图床之后特别爽。至于 sm.ms 突然宕机、无法访问或者是后面不再提供免费服务，这些相对于白嫖来说就不算什么了😆。

### 看板娘

[# 给你的博客中加入真白看板娘](https://vensing.com/2018/10/21/Mashiro/) 里讲的比较清楚了，在头部引入 css 样式和在 layout <section> 后引入那一大串代码就行。我这里新建了一个 ejs 文件放入那一大串代码，然后通过 <%- partial('common/mashiro') %> 引入到layout 即可。

没有什么难度，注意 url 就行，调试的时候指定80端口启动服务器否则会出现加载不出图片和 model 的问题。 最终效果如下图：

![](https://i.loli.net/2019/07/13/5d29a5590a6ba18790.png)


### 其他

友链和关于页添加了一些东西，简单说来就是为了体现出我是一个二刺螈 ~