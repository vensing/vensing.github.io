---
title: 网站更新啦
categories:
  - 博客
tags:
  - 更新
abbrlink: 53383
date: 2018-09-17 21:12:18
toc: true
---

博客有了一些新变化 

<!--more-->

### 🎈 更好看的主题

主题使用的是[Snippet主题](https://github.com/shenliyang/hexo-theme-snippet "fork theme")，感谢作者，支持主题[Star一下](https://github.com/shenliyang/hexo-theme-snippet/stargazers)。主题下载地址：[Snippet主题](https://github.com/shenliyang/hexo-theme-snippet "fork me")。换上了好看的头部横幅banner🎐，后面考虑使用[Simple-Desktop-API](https://github.com/spencerwoo98/spencer-simple-desktop-api)每次刷新页面随机抽取图片显示。加入了一些社交链接，不过貌似也不会有人关注我🙈。

### 🎄 接入评论服务

国内免费的评论服务好像都凉了，这个主题默认推荐的是[来必力](https://livere.com/)评论服务📥。注册了下账号，然后填了下URL，到安装界面可以拿嵌入代码和服务ID，拿到ID之后去当前主题下的配置文件中配置一下即可。更换URL要先冻结服务，填好新URL后再激活服务，耐心等待服务开启。

```yml
### 来必力
livere:
  enable: true
  livere_uid: *********
```

不过，来必力的服务好像不稳定😕，加上是高丽出品网速也不行🤣。如果找到好的评论插件并且主题支持，马上更换。


### 🌎 更换了域名

去阿里云淘了一个.site的域名🛒，然后去github.io项目下加入了custom domain。现在你可以通过<https://vensing.site>来访问本博客了🚀。
  
这里简单说下我配置的DNS解析，首先去Ping一下你的github pages `*****.github.io`地址的IP。然后解析列表下添加一个A记录类型的解析，主机记录填@**[也就是为空的意思]**，记录值填刚才Ping的IP地址，解析线路默认。再新建一个别名解析，类型选择CNAME，主机记录填`www`，记录值填github pages的地址：`*****.github.io`，解析线路默认。
  
别名（CNAME）解析允许您将多个域名映射到同一台计算机。例如，有一台计算机名为`host.mydomain.com`（A 记录），它同时提供 WWW 和 MAIL 服务；为了便于用户访问服务，可以为该计算机设置两个别名（CNAME）：WWW 和 MAIL。这两个别名的全称就是`www.mydomain.com`和`mail.mydomain.com`。实际上他们都指向`host.mydomain.com`。

| 参数   | 说明                                    |
| ---- | :------------------------------------- |
| 记录类型 | 支持的记录类型包括:                            |
|      | A - 将域名指向一个IPv4地址。                    |
|      | CNAME - 将域名指向另外一个域名。                  |
|      | AAAA - 将域名指向一个IPv6地址。                 |
|      | NS - 为子域名指定DNS服务器。                    |
|      | MX - 将域名指向邮件服务器地址。                    |
|      | SRV - 用于记录提供特定服务的服务器。                 |
|      | TXT - 为记录添加说明，可用于创建SPF记录。             |
|      | CAA - CA证书颁发机构授权校验。                   |
|      | 显性URL - 将域名302重定向到另外一个地址，并且显示真实目标地址。  |
|      | 隐形URL - 将域名302重定向到另外一个地址，但是隐藏真实目标地址。  |
| 主机记录 | 域名前缀，与域名共同组成解析对象。假设域名为 a.com，则常见用法如下： |
|      | www：解析域名 www.a.com                    |
|      | @：直接解析主域名 a.com                       |
|      | \*：泛解析，解析所有子域名                        |
|      | mail：解析域名 mail.com，用于邮箱服务器            |
|      | m：解析域名 m.a.com，用于手机网站                 |
|      | 二级域名：例如填写 abc，用于解析 abc.a.com          |
| 解析线路 | 使用的解析线路                               |
| 记录值  | 根据记录类型设置解析结果                          |
| TTL值 | 解析结果在递归DNS中的保存时长                      |
