---
title: 网络抓包那些事
comments: true
toc: true
date: 2020-06-21 17:46:00
categories:
 - 博客开发
tags:
 - 抓包
 - 接口
---



最近摸了几天鱼，给博客加了两个菜单页，ONE 每日一图和电影日历。这篇文章我想讲一下如何快乐的摸鱼🐟~



<!-- more -->

### 也曾向往文艺的青年

摸鱼之前先来回忆下以前的事情。说起来，我在高中的时候就开始在 QQ 空间上写日志，最开始是看别人写日志，后面觉得光看别人写不过瘾，也就开始了自己写。当然，内容完全没有什么立意也没有主题和深度，当初竟然还能不嫌丢脸光明正大的发出来，以至于我现在将这些日志全部设置为仅个人可以查看。

随着岁月的无情摧残，我也已经从学校里的学生成长为不务正业的社畜摸鱼怪了。写日志的习惯倒是延续到了写博客文章，不过我已经不是那个向往文艺的青年了，我开始变得世俗起来，这又是另一回事了，有时间的话我还真想写写我自己。岁月无情的将一个曾经向往文艺的青年，变成了一个可悲可叹的摸鱼怪。

好了，回忆就先到这了。既然是向往文艺的青年，那肯定会接触一些文艺生活的信息啦。这里我想介绍下的是「ONE·一个」：

> App「一个」
每天只为你准备一张图片、一篇文字和一个问答
韩寒主编和监制 原《独唱团》主创成员共同制作
复杂世界里, 一个就够了. One is all.

这是官网介绍的 slogan，看得出来确实是有文艺的人会下载的 APP。一个 APP 里，每天都会推送一张图片和一段图文的「每日图文」，有点像一言的感觉。我倒是蛮喜欢这种每日图文的方式，有时候这么一张图和一段文字会让我们从浮躁的生活中脱离出来看到生活其实还有诗和远方，然后再重新融入滚滚红尘。所以，我就想把 ONE 每日图文加到博客里，既方便自己阅读也能让更多的人看到。

### ONE 每日图文接口

理由就是这么个理由，所以如何把每日图文的信息给抓到呢？

大概有这么几种方式：
- 写个爬虫，每天爬  ONE 的每日图文； 
- 谷歌一下，看看电脑网页端有没有暴露 API；
- 抓一下移动 APP 上的包，找出接口。

由于，我用的是 Hexo 静态博客，没有服务端而我又不愿意花钱买服务器，就为了这么一个小功能就写爬虫太不轻量了，所以爬虫就砍掉吧 (其实是我不会写爬虫ww。

#### 控制台抓取接口地址

作为程序员，当然得学会面向搜索引擎编程了，也很快就找到了ONE 网页端暴露的 API 接口。在 ONE 官网移动端就暴露了这么一个每日图文的接口：

![每日图文的接口](https://cdn.jsdelivr.net/gh/vensing/static@master/image/M9pUbR2zVx4q63I.png)

调试当然得打开控制台啦，Chrome 也为我们提供了模拟移动设备的环境，点击控制台左上角的【device toolbar】图标就可以切换模拟移动设备访问网页了。很幸运，我们很快就找到了每日图文的网址 API，这是一个 XHR ajax 请求，带了一个`_token` 参数。在控制台中，找到该请求的 `Initiator` 栏查看 Request call stack。最后我们会找到该请求的发起位置：

```javascript
    One.token = 'b15449f4a9c6a23f9e21ac1339c4b8e0b73767be';
    $(function () {
        var page = $('#myPage_angOne_index');
        One.listPage.init(page, 'http://m.wufazhuce.com/one/ajaxlist/');
    });
```
这个 `_token` 是随着 http://m.wufazhuce.com/one HTML 页面返回的；在第一次访问这个页面时，有一个 `Set-Cookie` 返回头，我们的 ajaxlist 请求的请求头需带上 `Cookie`，值就是刚才的`Set-Cookie` 返回的值，然后我们还得带上查询参数 `_token`。


我们可以在 `postman` 上测试下设置 `_token` 和 `Cookie` 后是否能正确访问到 API：

![one_postman.png](https://cdn.jsdelivr.net/gh/vensing/static@master/image/2ZWTwJmerUnBkYp.png)

可以看到我们已经能通过接口拿到一组数据了，当天的数据 (最新一条数据) 位于数组索引 0 的位置。

#### CloudFlare 反向代理接口地址

但是，我们还不能直接在我们的网站中发起 Ajax 异步请求调用这个 API，因为存在跨域问题。跨域问题我们可以使用 CloudFlare 的免费 Workers 功能反向代理 ONE 的 API 接口，同时设置下跨域请求头。设置反向代理时，需要发起两个请求，第一个请求的地址是 http://m.wufazhuce.com/one 页面，我们需要拿到第一次访问页面时，响应头的 `Set-Cookie` 返回值和 HTML 页面脚本中的 `_token` 值。第二个请求的地址是 http://m.wufazhuce.com/one/ajaxlist/ ，设置请求头 `Cookie` 的值为刚刚拿到的`Set-Cookie` 返回值，以及带上 `_token` 查询参数。

这样的一通操作下来，我们就能在我们的网站中拿到 ONE 每日图文的数据了。具体的代码参见：[OneTodayWorker.js](https://github.com/vensing/OneToday/blob/master/OneTodayWorker.js) 借鉴和参考了 disqusjs 官方提供的 CF 反代示例， ONE 每日图文使用方法查看 [OneToday](https://github.com/vensing/OneToday) 仓库的 README 文件。

由于，第二种方式就能实现我所需的功能，所以移动设备抓包获取接口地址就没考虑了ww。

### 豆瓣电影日历

说起来，豆瓣也经历过 14 个年头的站点了，而豆瓣也好像一直没有令人印象深刻的 slogan ，倒是豆瓣电影和书影音档案成为了相关内容的百科全书。豆瓣大约在 2017 年推出了 [『豆瓣电影日历』](https://book.douban.com/subject/34775984/) 纸质日历，每天推荐一部高分电影，并且在 IOS 的 Today Widget 上有电子版『豆瓣电影日历』和纸质日历同步，这个功能很多人并不知道。

![豆瓣电影日历](https://cdn.jsdelivr.net/gh/vensing/static@master/image/GtdAbWJIpnmBlYQ.jpg)

豆瓣电影日历和 ONE 每日图文的展示形式类似，以一张图一段文字每天推荐一部高分电影。那么能不能像 ONE 每日图文那样抓取接口地址呢？

#### IOS 上使用抓包软件

经过一番折腾，我排除了网页端暴露 API 接口的方式，爬虫也没有办法，因为只有在 IOS 上才有豆瓣电影日历。所以，问题就来到了如何在 IOS 上抓包的问题。IOS 上有很多款抓包软件，其中比较出名的两款是：

 - Stream，免费，功能也完善
 - Thor，付费且功能完善

这两款软件的安装步骤都基本一致：

1. 安装证书：设置 > 通用 > 描述文件 > 进入描述文件详情 > 安装
2. 信任证书：设置 > 关于本机 > 证书信任设置

**注意：** 请做好第二步，信任证书，否则使用 Stream 抓取走 https 协议的站点时，会报kCFStreamErrorDomainSSL 错误，Thor 也一样要信任证书。我就是在这边被坑了一阵子 (

抓包软件的原理如下：

> **HTTPS 解析原理**
Thor 实现的 HTTPS 解析方式是 MiTM （中间人欺骗）：需要用 Thor SSL CA 根证书针对特定域名生成叶子证书，用此叶子证书跟客户端（请求发起方）通信，并成功解析流量。
客户端（请求发起方）如果做了证书本地验证（即验证跟它通信的叶子证书是否是它原来商定好的证书），那么 Thor 生成的叶子证书跟客户端之间的 SSL 连接将会失败，自然就也解不了这类流量。
总之 HTTPS MiTM 不是万能的，望知晓。


所以，Thor 和 Stream 都需要设置开启系统 VPN 代理功能，才能进行抓包，这就意味着你无法在手机上一边开启VPN 科学上网一边使用 Thor 或 Stream  来进行抓包。Thor 并非万能，只工作在系统 HTTP 层: 不支持非 HTTP 流量(TCP, UDP)及不经过系统 HTTP 代理的流量。

[点此查看 Thor 使用帮助](https://github.com/PixelCyber/Thor/blob/master/README-zh-Hans.md)，特别感谢 [东方幻梦](https://blog.badapple.pro/) 同学给我 Apple ID 白嫖 Thor。

#### 抓取电影日历接口

抓包这个操作，其实很简单，先把其他软件从后台切出防止不必要的网络请求。然后，进入软件首页点击按钮开启抓包，iPhone 切到 Today Widget 小组件页面(需先开启豆瓣每日电影 Widget )即可，返回抓包软件，即可看到抓到的请求。

![抓包结果——请求头](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Qfmv3nykSt6xVHs.jpg)

最重要的是请求头和请求行，我们可以在 `Postman` 上，输入上述请求头及请求地址和查询参数：

![Postman测试接口成功](https://cdn.jsdelivr.net/gh/vensing/static@master/image/dgLZTvyn47QzGCe.png)

请求头，按抓取的请求头设置即可，查询参数中我们只需要替换 `date` 参数即可；`_ts` 是时间戳和 `_sig` 签名应该是对应关系所以可以不用管。返回头中 Cookie 的过期时间貌似设置的是不过期，最理想的情况是我们使用抓取到的请求头和查询参数配置我们自己的请求即可，需要替换的只是 `date` 日期。而 Cookie 和 签名这些是否会随着时间改变这些也无从验证(按道理是不会变的)，没办法别人的接口又没公开，只能这么干啦。


#### 反向代理电影日历接口

和 ONE 每日图文一样，我们还不能直接在我们的网站中发起 Ajax 异步请求调用这个 API，因为存在跨域问题。这里同样可以使用 CloudFlare 的免费  Workers 功能反向代理 API 接口，同时设置下跨域请求头和查询参数。

关于代理的配置，比  ONE 每日图文的配置还要简单，因为电影日历可能会涉及到版权问题，所以这里的反向代理代码就不公开了。因为豆瓣的公共 API 都下线了，所以现在都需要加上 apikey，个人使用应该也没啥大碍。

还有一个接口返回的图片 url 在博客网站上出现 403 防盗链的问题，这里我使用了 https://images.weserv.nl/?url= 提供的服务进行反代解决。


### 最后

可以在本站导航栏上的 `One 图文` 和 `电影日历` 菜单项查看，放下效果图：

![ONE 每日图文](https://cdn.jsdelivr.net/gh/vensing/static@master/image/AE1HZaONsXVyrf6.png)

![豆瓣电影日历](https://cdn.jsdelivr.net/gh/vensing/static@master/image/3PXlrJeR7j9oZnd.png)

这两个接口都只在个人博客使用，方便查阅每日更新，不用于商业或者其他用途。如有侵权，请联系我删除。

###  参考

- [图文 - 「ONE · 一个」 官方API分析](https://www.jianshu.com/p/e9617107b748)
- [disqusjs CF Workers  反代示例](https://github.com/idawnlight/disqusjs-proxy-cloudflare-workers/blob/master/worker.js)

### 感谢
感谢 [cloudflare.com](cloudflare.com) 提供的免费 Worker 服务。