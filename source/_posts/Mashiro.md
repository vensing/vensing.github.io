---
title: 在你的博客中加入真白吧
comments: true
categories:
  - 插件
tags:
  - 插件
  - 更新
img: '/img/Shiina_Mashiro.png'
abbrlink: 14781
date: 2018-10-21 21:07:29
---

## 在你的博客中加入真白看板娘💎
![](/img/Shiina_Mashiro.png)

&emsp;&emsp;本文基于[教程 | 将椎名真白放到你的博客做看板娘](https://mp.weixin.qq.com/s/lVIC7WPXrs6y2ol6O1A0SA)搬运，具体用法也是基于此。作者博客地址：[https://zflytree.tk](https://zflytree.tk)。<br/>

&emsp;&emsp;更多信息参阅[伊斯特瓦尔点这里](https://www.wikimoe.com/?post=76)地址，和[《给博客添加能动的看板娘(Live2D)-将其添加到网页上吧》](https://imjad.cn/archives/lab/add-dynamic-poster-girl-with-live2d-to-your-blog-02)。文字部分参考自[在 Web 上展示 Live2D 吧！](https://github.com/galnetwen/Live2D)

&emsp;&emsp;[椎名真白](https://zh.moegirl.org/%E6%A4%8E%E5%90%8D%E7%9C%9F%E7%99%BD)请点击萌娘百科[椎名真白条目](https://zh.moegirl.org/%E6%A4%8E%E5%90%8D%E7%9C%9F%E7%99%BD)，爱真白真是太好了。


### 1. 获取文件

1. 首先，准备好Live2dMashiro.zip文件。

2. 将解压出来的live2d文件夹拷到你的网页目录中。
![live2dmashiro](/img/live2dmashiro.png)

### 2. 加入代码

3. 在 <head\>标签内引入如下css样式代码，如果路径有变请按照自己的情况更改：
```css
<link  rel="stylesheet" href="blog/live2d/css/live2d.css"  />
```
&emsp;&emsp;因为本站由 [Hexo](https://hexo.io/)强力驱动，主题基于[Snippet](https://github.com/shenliyang/hexo-theme-snippet.git)，所以在这需做如下配置：
&emsp;&emsp;在主题` themes\hexo-theme-snippet\layout\_partial `目录下，修改head.ejs，也就是在<head\>标签中引入上述css。

4. 在<body\>标签中加入如下代码：
```html
<div id="landlord" style="left:5px;bottom:0px;">
    <div class="message" style="opacity:0"></div>

    <canvas id="live2d" width="500" height="560" class="live2d"></canvas>

    <div class="live_talk_input_body">
    	<div class="live_talk_input_name_body">
        	<input name="name" type="text" class="live_talk_name white_input" id="AIuserName" autocomplete="off" placeholder="你的名字" />
        </div>
        <div class="live_talk_input_text_body">
        	<input name="talk" type="text" class="live_talk_talk white_input" id="AIuserText" autocomplete="off" placeholder="要和我聊什么呀？"/>
            <button type="button" class="live_talk_send_btn" id="talk_send">发送</button>
        </div>
    </div>

    <input name="live_talk" id="live_talk" value="1" type="hidden" />
    <div class="live_ico_box">
    	<div class="live_ico_item type_info" id="showInfoBtn"></div>
        <div class="live_ico_item type_talk" id="showTalkBtn"></div>
        <div class="live_ico_item type_huanzhuang" id="huanzhuangButton"></div>

        <div class="live_ico_item type_music" id="musicButton"></div>
        <div class="live_ico_item type_youdu" id="youduButton"></div>
        <div class="live_ico_item type_quit" id="hideButton"></div>
        <input name="live_statu_val" id="live_statu_val" value="0" type="hidden" />
        <audio src="" style="display:none;" id="live2d_bgm" data-bgm="0" preload="none"></audio>

        <input name="live2dBGM" value="https://t1.aixinxi.net/o_1c52p4qbp15idv6bl55h381moha.mp3" type="hidden">
        <input name="live2dBGM" value="https://t1.aixinxi.net/o_1c52p8frrlmf1aled1e14m56una.mp3" type="hidden">
        <input id="duType" value="douqilai,l2d_caihong" type="hidden">

    </div>
</div>

<div id="open_live2d">召唤椎名真白</div>
<script type="text/javascript" src="https://apps.bdimg.com/libs/jquery/1.7.1/jquery.min.js"></script>
<script>
var message_Path = '/live2d/';//资源目录，如果目录不对请更改
var talkAPI = "";//如果有类似图灵机器人的聊天接口请填写接口路径
</script>

<script type="text/javascript" src="blog/live2d/js/live2d.js"></script>
<script type="text/javascript" src="blog/live2d/js/message.js"></script>
```

&emsp;&emsp;此次的代码也需另做修改：
&emsp;&emsp;在主题`themes\hexo-theme-snippet\layout`目录下找到layout.ejs，在<body\>标签中的<section\>标签后加入上述代码即可。此处ejs文件中博客目录的地址是`<%= config.url%>`，应该是从主题配置文件中拿到的root path url，所以将js中的blog`src="blog/live2d/js/live2d.js"`改为`src="<%= config.url%>/live2d/js/live2d.js"`。其他js引入做类似修改即可。

### 3. 效果展示

&emsp;&emsp;代码引入没什么好讲的，细心做好上述两处引入代码的步骤，让文件正确引入和URL地址设置准确就基本完成了，测试下效果即可。

&emsp;&emsp;将真白加入本站的效果图如下：
![椎名真白看板娘](/img/mashiropng.png)

&emsp;&emsp;目前加载文件的速度有待提高，点击给真白换装时要等2~3s，也不是不能接受的嘛。


