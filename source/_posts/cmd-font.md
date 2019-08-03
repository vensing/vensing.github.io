---
title: 一种实用的 Windows PowerShell 和 cmd 字体 
comments: true
toc: true
date: 2019-07-28 10:26:23
categories: 插件
tags: cmd 

---

**电脑有问题怎么办呢?**

一般来说，是有三种解决办法的：

>- 重启解决90%的问题
- 重装解决99%的问题
- 重买解决100%的问题


![](https://i.loli.net/2019/07/28/5d3d09de99cc583408.png)

最近由于某些原因 (戴尔全家桶和家庭版) 和我实在贫穷不能重买解决100%的问题，所以我选择了重装系统。

>### 难看的cmd

重装完系统之后第一件事当然就是下各种软件啦，然后配置各种环境变量。在配置环境变量的过程中难免会用到 cmd 控制台。可能有些人就要发表不同意见了，装个 Git 不就好了？当然，安装了 git 后，会自动帮我们安装 mintty，bash 风格，自定义方便，着色也很棒。但在某些情况下，Git 却很容易吃瘪：

![](https://i.loli.net/2019/07/28/5d3d0d32f3c9760716.png)

因此，总有免不了要用 cmd 的时候，或者虽然强大但很丑的 PowerShell。

众所周知 Windows 系统下的命令行界面，字体要么是点阵字体，要么是宋体；但无论哪种，始终都觉得有些个难看。然而，字体选择界面却始终没办法选择到我们新安装的各种字体。

<!--more-->

>###  字体要求

所以在 cmd 下有没有一种好看的字体呢？有没有，咱去巨硬官网看看就知道了。

微软说，cmd 和 PowerShell 对字体的要求非常苛刻，在 [Necessary criteria for fonts to be available in a command window](https://support.microsoft.com/zh-cn/help/247815/necessary-criteria-for-fonts-to-be-available-in-a-command-window) (现在已经404) 一文种就有说到：

> The fonts must meet the following criteria to be available in a command session window:

- The font must be a fixed-pitch font.
- The font cannot be an italic font.
- The font cannot have a negative A or C space.
- If it is a TrueType font, it must be FF_MODERN.
- If it is not a TrueType font, it must be OEM_CHARSET. Additional criteria for Asian installations:
- If it is not a TrueType font, the face name must be “Terminal.”
- If it is an Asian TrueType font, it must also be an Asian character set.

翻译过来是：

> 要能在命令行种使用，字体必须满足：

- 必须是等宽字体
- 不能是斜体
- 该字体不能有A或C负空间
- 如果是 TrueType 字体，则它必须是 FF_MODERN
- 如果不是 TrueType 字体，则它必须是 OEM_CHARSET 如果是给亚洲地区使用，还必须满足这些条件：
- 如果不是 TrueType 字体，字体名必须是“Terminal” ，如果是亚洲的 TrueType 字体，还必须使用亚洲的字符集。

好吧，你是巨硬，你家的平台你说了算；这特么的不是一般字体能满足的啊。

>### 可用的字体

这里只推荐一款出自巨硬之手的字体：
[Microsoft YaHei Mono](https://github.com/Microsoft/BashOnWindows/files/1362006/Microsoft.YaHei.Mono.zip) ，微软为 WSL/Bash on Ubuntu on Windows 设计的字体，PowerShell 和 cmd 也能用，效果相当于微软雅黑和 Consolas 的混搭。

在cmd 或者 powershell 窗口的标题栏右键，进入属性窗口，选择字体为 Microsoft YaHei Mono 后确定即可。

![](https://i.loli.net/2019/07/28/5d3d15c25841b46636.png)

使用的前后效果如下：

![使用前，默认的 cmd 字体](https://i.loli.net/2019/07/28/5d3d1798bf8fb84177.png)

![使用后，Microsoft YaHei Mono 字体](https://i.loli.net/2019/07/28/5d3d133f7bae978945.png)

![使用前，默认的 powershell字体](https://i.loli.net/2019/07/28/5d3d0ddc3d5c827279.png)

![使用后，Microsoft YaHei Mono 字体](https://i.loli.net/2019/07/28/5d3d0ddc9df5a93731.png)


>### 参考

绝大部分内容参考自 [# 自定义 Windows PowerShell 和 cmd 的字体](https://blog.walterlv.com/post/customize-fonts-of-command-window.html)  _(:з)∠)_ 。
