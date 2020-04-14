---
title: Tomcat 开启 gzip 压缩
comments: true
toc: true
date: 2019-08-24 10:26:23
categories: 开发
tags: gzip 
---



### 背景	

最近公司让做了一个示例项目，部署到阿里云后，客户反馈第一次进入登录页面非常慢，有多慢呢？说出来你可能不信，2M 的 js、css、png 等静态资源加载出来竟然需要15多秒？

<!--more-->

然后我赶紧打开Chrome控制台看一看到底是不是真的那么慢，一看卧槽这慢的简直想让人砸电脑了。


砸电脑是不可能砸的，那还是乖乖想办法定位问题，排除优化下。但是我那些 js，css，等静态文件都已经压缩过一遍了，没理由两三百k的 js 加载八九秒的啊？嗯，不是客户端网速慢，也不可能是我首页登录代码有问题(首页我就跳转个界面)。

然后我就想啊想，后知后觉的发现，不对啊这特么完全是服务器带宽的锅。2Mbps 的带宽，算下来也就是 256kb/s (2048/8) 不到，难怪登录页直接嗝屁了。


### gzip压缩

明确了带宽的问题，那就好办了。花钱提高带宽呗，嗯领导貌似不会同意。那能不能服务器传输静态资源给客户端时压缩下呢？

<img style="width: 50%;" src="/img/wfsdsdf.jpg" />

答案是有的，比如 gzip。


但是不是每个浏览器都支持 gzip 的，如果知道客户端（即浏览器）是否支持gzip呢，请求头中有个 Accept-Encoding来标识对压缩的支持。客户端http请求头声明浏览器支持的压缩方式，服务端配置启用压缩，压缩的文件类型，压缩方式。

![](https://i.loli.net/2019/08/24/ldo4Lqr3cta6jTW.png)

当客户端请求到服务端的时候，服务器解析请求头，如果客户端支持gzip压缩，服务器响应时对请求的资源进行压缩并返回给客户端，浏览器按照自己的方式解析，在http响应头，我们可以看到 content-encoding:gzip，这是指服务端使用了gzip 的压缩方式。

![](https://i.loli.net/2019/08/24/hTxzrJA6FN4l58q.png)

那么怎么看有没有用 gzip 压缩的文件呢，打开 f12，查看 network，按照下面的方式过滤：

![](https://image-static.segmentfault.com/550/790/550790173-5a409a4737315)

content-encoding 是 gzip 的话就说明返回的是 gzip。

### tomcat 如何启用gzip

由于项目采用 Java 作为后台开发语言，所以本文只针对 tomcat 服务器。有关于 node 端、Nginx 端开启 gzip，参考：[前端性能优化之gzip](https://segmentfault.com/a/1190000012571492)

找到 tomcat 的 server.xml 文件，找到其中 Connector 节点然后进行配置修改，具体配置如下：

```xml
    <Connector port="8080" protocol="HTTP/1.1"
               connectionTimeout="20000"
               redirectPort="8443" 
			   compressableMimeType="application/javascript,text/css" 
			   compression="on"
			   useSendfile="false"
			   compressionMinSize="2048"/>
```

参数说明：

| 参数项 | 释义 |
| ---- | :-----: |
| compression="on" | 打开压缩功能  |
| compressionMinSize="2048" | 启用压缩的输出内容大小，<br/>当被压缩对象的大小>=该值时才会被压缩,<br/>默认为2KB(即2048) |
| noCompression<br/>UserAgents="gozilla" | 对于以下的浏览器，不启用压缩 |
| compressable<br/>MimeType=text/css... | 压缩类型 |
|  **useSendfile="false"**  | 让大文件也能进行gzip压缩，<br/>否则gzip只会压缩 2k~50k左右的文件<br/> |


(useSendfile="false" 请 参考：[tomcat gzip compression not working for large js files](https://www.cnblogs.com/leon032/p/3512915.html))

**注意：** 

tomcat7以后，js文件的mimetype类型变为了**application/javascript**，而在tomcat7以下则为**text/javascript**，具体的tomcat7定义的类型可以在：conf/web.xml文件中找到。

可以在web.xml下搜索，会找到如下代码：
```xml
<mime-mapping>
    <extension>js</extension>
    <mime-type>application/javascript</mime-type>
</mime-mapping>
```
或者，查看开发人员控制台可以看到 js 请求的响应头是：`Content-Type: application/javascript`。


### 总结

在 tomcat 开启gzip压缩之后，由原来的十几秒直接缩短到了2~3秒。

开启 gzip 压缩能够大幅度压缩js、css等文件的大小，大约能压缩40%~50%压缩，效率惊人，从而提高页面加载响应速度，这对于带宽很小的服务器提升非常明显。但开启gzip压缩之后可能会不利于搜索引擎检索。

### 参考

1. [前端性能优化之gzip](https://segmentfault.com/a/1190000012571492)
2. [Tomcat 6.0 GZIP Compression not working for large js files](https://grokbase.com/t/tomcat/users/111d593qft/tomcat-6-0-gzip-compression-not-working-for-large-js-files)
3. [tomcat gzip compression not working for large js files](https://www.cnblogs.com/leon032/p/3512915.html)