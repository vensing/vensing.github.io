---
title: pjax下如何使用fancybox预览图片
comments: true
toc: true
date: 2020-04-19 16:31:00
categories:
  - 博客开发
tags:
  - fancybox
  - pjax
---

在 pjax 下使用 fancybox.js 插件预览图片。

<!-- more--> 


### pjax 

熟悉单页应用的朋友都知道，在点击一个链接的时候，是不会做页面跳转的，而是仅仅做页面刷新不会造成整个页面闪一下的感觉。局部刷新的体验肯定是比页面跳转好得多的，pjax 就是为此而出现的。H5 pushState 和 replaceState API 的出现让 url 可以摆脱丑陋的hash  # 号做页面刷新，结合 popstate 事件监听浏览器的前进后退，更改内容和页面 title 。

pushState 的功能主要是修改 url 地址却不会跳转页面，该 url 也会存放到浏览器的历史记录中去。 replaceState 和 pushState 的功能类似，但是它不会将 url 放到浏览器历史记录中。popState 监听浏览器的前进后退，且能获取设置的 state。

Kratos-Rebirth 主题采用了pjax 技术做页面刷新而无需页面跳转，它的原理主要如下：

1. 当用户点击 a 标签的时拦截超链接；
2. 拦截后做两步操作，使用 ajax 获取 html 页面代码和做 pushState 操作。

这样就能做到页面刷新而不会闪一下地跳转页面 (ajax 是好文明)。当然这种方式不是最好的，更好的方案是观察者模式，在 state 改变时触发而不是点击 a 标签的超链接时触发，但 hexo 的倾向就是简单化，所以观察者模式的 pjax 就砍掉吧。

Kratos-Rebirth 主题 pjax 的具体 实现：https://github.com/Candinya/Kratos-Rebirth/blob/master/source/js/pjax.js

###  fancybox

[fancybox](https://github.com/fancyapps/fancybox) 是一个图片预览插件，能以模态框弹窗的形式更好更方便的缩放查看图片。在给 Kratos-Rebirth 主题加入 fancybox 图片预览插件时，我是按照 landscape 主题的 fancybox 插件来实现。

#### 引入 css 和 js 

在head.ejs 里引入  jsDelivr 的 [jquery.fancybox.min.css](https://cdn.jsdelivr.net/npm/@fancyapps/fancybox@3.5.7/dist/jquery.fancybox.min.css) 及在 foote.ejs  里引入  jsDelivr 的 [jquery.fancybox.min.js](https://cdn.jsdelivr.net/npm/@fancyapps/fancybox@3.5.7/dist/jquery.fancybox.min.js) (版本需和 landscape 使用的 3.5.7 一致)。

#### 注册 fancybox 

在主题目录下新建一个scripts文件夹(如果没有)，然后把 [fancybox.js](https://github.com/hexojs/hexo-theme-landscape/blob/master/scripts/fancybox.js) 拷贝一份到这个目录下。

最后在页面就绪加载函数里加入初始化代码：

``` javascript
var fancyboxInit = ()=>{
    $('.kratos-hentry').each(function(i){
        $(this).find('img').each(function(){
          if ($(this).parent().hasClass('fancybox') || $(this).parent().is('a')) return;
          var alt = this.alt;
          if (alt) $(this).after('<span class="caption">' + alt + '</span>');
          $(this).wrap('<a rel="gallery" href="' + this.src + '" data-fancybox=\"gallery\" data-caption="' + alt + '"></a>')
        });

        $(this).find('.fancybox').each(function(){
          $(this).attr('rel', 'article' + i);
        });
      });

      if ($.fancybox){
        $('.fancybox').fancybox();
      }
}
```

注：上述的 `.kratos-hentry` 选择器是 hexo 文章部分 article 标签上的 class 样式名，请务必对应起来。

#### 开始食用

到这应该就差不多能食用 fancybox 预览图片了，好耶。如果你这么想，就大错特错了我的朋友。当你正准备打开浏览器页面测试下 fancybox 图片时，你不知道摆在你前面的是一个大坑。

![咋回事？](https://cdn.jsdelivr.net/gh/vensing/static@master/image/umqwPHbjrU1Qysv.jpg)

嗯？咋没有模态框弹出来？咋跳到图片原始链接的页面了？你是否有很多问号？？？控制台说 pjax 不能解析 PNG，然后下面是一堆乱码 (其实就是图片)。你可能会想 fancybox 服务没用，关 pjax 毛事，但确实是 pjax 的锅。


### pjax 过滤 fancybox 请求

看看上面的代码，fancybox 给文章 DOM 节点下的  img  包裹上了一层 a 标签，然后当你点击它时 pjax 就起作用了。既然出了 bug 那就硬着头皮修呗，那 pjax 拦截时，判断下 url 是图片的后缀是不是有效呢？理论上是可以的，但这样你得去判断图片类型这未免有点复杂，我只是想用个插件啊。更好的方式是，过滤 fancybox 包裹在 img 上的 a 标签，那就给 a 标签加个 rel 属性过滤。最后的代码是这样的：

```js
$(document).on("click", 'a[target!=_blank][rel!=gallery]', function() {
    //var fancybox = $(this).data('fancybox');
    //if(fancybox && fancybox === 'gallery') return false;
    var req_url = $(this).attr("href");
    if (req_url === undefined) return true;
    else if (req_url.indexOf( "javascript:") !== -1) return true;
    else ajax(req_url, true);
    return false;
});
```

其实，也可以用 $(this).data('fancybox') 获取 fancybox 给 img 包裹的 a 标签的 data-fancybox 属性值，然后判断等于gallery 的话就跳出回调函数返回 false 。但很明显，过滤器的方法更优雅一些。

### 总结

fancybox 会对 markdown 文件里的  \!\[\]\(imgurl\) 做超链接包裹，\<img\>  也同意会被处理。但是，如果你用 js 编程的方式添加图片的话，fancybox 是不会对图片做处理的即不会被超链接包裹。

Kratos-Rebirth 采用 jsDelivr CDN 引入各种 css、js 依赖，在选择 npm 源时，直接搜 fancybox 最新版本在 3.0.1；然后就打算用 github 的源，这里记录下如何用 jsDelivr 链接到 GitHub 的源：

- https://cdn.jsdelivr.net/gh/你的用户名/你的仓库名@发布的版本号/文件路径

最后发现，npm 源下搜 fancyapps 关键词才能找到最新版，有点搞 (雾 。你可以去[https://github.com/Candinya/Kratos-Rebirth/pull/5](https://github.com/Candinya/Kratos-Rebirth/pull/5) 查看我提交的 fancybox 插件 PullRequest。

### 后续

因为 fancybox 默认是采用 hash 模式，即在 url 后边加 # 号弹窗预览图片；这会导致该 url 被添加到地址栏及浏览器历史记录中去，当 popstate 事件监听时会出现图片弹窗在其他页面的错误以及重复的历史记录。因此，在[Kratos-Rebirth#commit-ddf0417](https://github.com/Candinya/Kratos-Rebirth/commit/ddf0417d418674e69c069528cccd0d1aceca66f0) 我们禁止了hash模式 `$.fancybox.defaults.hash = false;`，fancybox 给图片包裹的 a 链接不再出现在地址栏和浏览器历史记录中，fancybox 应该是使用了 replaceState 方法实现这一特性。至此 fancybox 弹窗预览图片的功能已基本完善。