---
title: VS Code 搭建 SICP 环境
comments: true
toc: true
date: 2021-03-14 10:13:37
pic: ../images/sicp.jpeg
categories:
  - 编程札记
tags:
  - sicp
  - racket
---

其实这次算是乱点技能树了，不过看了 SICP (计算机程序的构造和解释) 的序言部分以及 [Why I Still ‘Lisp’ (and You Should Too)](https://betterprogramming.pub/why-i-still-lisp-and-you-should-too-18a2ae36bd8)，又让我觉得这样一本经典之作是值得花些时间去深入了解的。

<!-- more -->

在正式进入「VS Code 搭建 SICP 环境」主题前，按照惯例我们先来看点别的东西，干巴巴的单刀直入太过于枯燥和无聊了。

### 为什么不能乱点技能树

最早了解到「函数式编程」大概是大二、大三那会，因为 `google-hosts` 项目关注了项目作者的知乎账号，然后就看到了他回答的一个问题：[为什么不能乱点技能树？](https://www.zhihu.com/question/37009570/answer/70300644)

> 当你学会 oop 后突然觉得是不是掌握更多 paradigm 能帮助你学得更好，于是你开始学习 fp,你开始学习 ocaml haskell scheme 并比较各自优劣，而且每天还要花大量时间来和 oop 教徒争论fp 和 oop 哪个好。不知过了多久，你终于明白了很多东西如 lambda func, higher order func, lazy evaluation, closure的学习不应该局限于一门语言，你暗自窃喜自己发现了可称之为思想的东西，同时你能风轻云淡的用寥寥几行代码实现 currying, monad, 闲时还可以写点博文“对王垠40行CPS变换的改进”，你可能被人认为是大神并接受膜拜，但是内心里你很清楚自己不过是入门，因为你不懂数学，你越来越觉得这种充满数学 Ph.D 气息的范式没有数学基础很难了然细节，于是你试着学习 lambda calculus, type theory，category therory，abstract algebra 学到这里你突然哭了:"我这一辈子到底做了什么，没有女朋友，没有房没有车，还得整天和年轻人待在一起讨论 ‘lisp s-expression 真的优于数学形式的符号吗‘ 等这样看起来就很操蛋的问题" 当你意识到这点并想起你的初衷不过是想更深入明白 oop 的时候你的大学高中同学都在响应国家政策准备生二胎了这就是乱点 skill tree 的后果，所以心不要太大，样样懂不见得好，尤其是仅仅是“懂”，要学会适可而止（虽然道理人人都能说，但能做的少之又少，就比如我也做不到，这也算年轻的表现吧）
作者：kelthuzadx，链接：https://www.zhihu.com/question/37009570/answer/70300644

看完就觉得很真实，学到这里你突然哭了：“我这一辈子到底做了什么，没有女朋友，没有房没有车，还得整天和年轻人待在一起讨论 ‘lisp s-expression 真的优于数学形式的符号吗‘ 等这样看起来就很操蛋的问题”。嗯，作者那时候还在念高中，就已经对现实了解的如此透彻。

---

### SICP 序言

后面的话，就从各种各样的站点上提到了 SICP 这本书有多么多么经典和神圣：可能是最好的计算机科学的入门书，而且它的确把讲授编程作为理解计算机科学的一种方法。但它具有挑战性，会让许多通过其它方式可能成功的人望而却步。

关于 SICP 不做过多解释，也没有全面了解完，想看的人自然会去看，不想看的人也不会硬着头皮去看，不知道的人那就希望你能早点了解到。为什么我会想水这么一篇文章呢，很大一部分原因是受 SICP 里面的序言影响，然后也顺便记录下自己的开始，虽然搁置了特别久了。

> 带着崇敬和赞美，将本书献给活在计算机里的神灵。
“我认为，在计箅机科学中保持计算中的趣味性是特别重要的事情。这一学科在起步时饱含着趣味性。当然，那些付钱的客户们时常觉得受了骗。一段时间之后，我们开始严肃地看待他们的抱怨。我们开始感觉到，自己真的像是要负起成功地、无差错地、完美地使用这些机器的责任。我不认为我们可以做到这些。我认为我们的责任是去拓展这一领域，将其发展到新的方向，并在自己的家里保持趣味性。我希望计算机科学的领域绝不要丧失其趣味意识。最重要的是，我希望我们不要变成传道士，不要认为你是兜售圣经的人，世界上这种人已经太多了。你所知道的有关计算的东西，其他人也都能学到。绝不要认为似乎成功计算的钥匙就掌握在你的手里。你所掌握的，也是我认为并希望的，也就是智慧：那种看到这-机器比你第一次站在它面前时能做得更多的能力，这样你才能将它向前推进。
AlanJ. Perlls ( 1922年4月1日- 1990年1月7日 ）

「带着崇敬和赞美，将本书献给活在计算机里的神灵」一开始就是严肃的话，对计算机保有敬畏之心，太多书本都是一上来就对背景或者其他类似的大张旗鼓地吹嘘。如果你看的书，一开始是一个故事性质的或者是阐述现实事情的，那么大概率这会是一本好书。在这一方面，O'Reilly 出版的书籍就做的很好，动物书封面及其书籍内容广受好评。

「你所知道的有关计算的东西，其他人也都能学到。绝不要认为似乎成功计算的钥匙就掌握在你的手里」编程并不是垄断性质的，恰恰相反它是开放和包容性的，开源社区就是很好的佐证。任何人都能阅读各种源代码，或者是通过其他东西学到更多的编程知识。


{% alertbox info "

当然学习 SICP 不是为了炫技，而是为了掌握到更多的有关程序设计的方法思想和构建优雅的复杂程序。

" %}

### VS Code 搭建 SICP 环境

SICP 中选用的是 Lisp 中的 Scheme 方言，由于 `MIT Scheme` 这个开发环境实属古老，所以在参考了众多他人的方案之后，选择使用 Racket 作为 SICP 开发环境。当然如果你还是想体验 `MIT Scheme` 来学习的话，可以参考 [裴宗燕老师的 MIT Scheme 的基本使用](https://www.math.pku.edu.cn/teachers/qiuzy/progtech/scheme/mit_scheme.htm)。

> Racket 是一门受 Scheme 影响发展出来的通用、多范型，属于Lisp家族的函数式程序设计语言，它的设计目之一是为了提供一种用于创造设计与实现其它编程语言的平台，Racket被用于脚本程序设计、通用程序设计、计算机科学教育和学术研究等不同领域。

Racket 对 Scheme 有着很好的支持，且更新非常频繁，有提供 SICP 的支持，所以选择使用 Racket 作为 SICP 开发环境。首先当然是下载 Racket 语言软件包，https://download.racket-lang.org/ 提供了 macOS、Windows、Unix、Linux 下的安装包；下载操作系统对应的软件包安装即可，安装完成后还会提供一个 DrRacket 编辑器。

使用 VS Code 作为编辑器需要安装一些依赖:
 
- Magic Racket VS Code 插件扩展
- racket-langserver Racket 依赖包
- sicp 依赖包

#### [Magic Racket 扩展插件](https://github.com/Eugleo/magic-racket)

> This extension adds support for Racket to VS Code. With the newly added support for language server protocol, we're proud to say that Magic Racket is the best Racket extension for VS Code.

[Magic Racket](https://github.com/Eugleo/magic-racket) 扩展插件通过新增加的语言服务器协议提供了 VS Code 下对 Racket 语言的支持。在此之前我们需要将 Racket 添加到系统环境变量中，由于我用的 macOS zsh bash，所以在用户目录下的 .zshrc 里添加：

```bash
# 注意空格处理
export RACKET="/Applications/Racket v7.9"
export RACKET=/Applications/Racket\ v7.9
export PATH=$RACKET/bin:$PATH
```
如果环境变量路径中带有空格的需要用双引号包裹起来或者用反斜杠转义下空格，Windows 下添加环境变量路径不再赘述。最后执行如下命令查看是否配置成功：

```bash
source .zshrc
echo $PATH

racket -V
Welcome to Racket v7.9 [bc].

# racket 包管理器
raco help
```

在 VS Code 扩展商店中安装 `Magic Racket`，点击该插件的齿轮⚙图标进入扩展设置，Racket Path 直接填 racket 即可。更多的插件用法请查看 Github 代码库。


![](https://chee5e.space/static/image/magic_racket.png)

#### [racket-langserver](https://github.com/jeapostrophe/racket-langserver)

> racket-langserver is a Language Server Protocol implementation for Racket. This project seeks to use DrRacket's public APIs to provide functionality that mimics DrRacket's code tools as closely as possible.

使用 raco 安装 racket-langserver 依赖包：

```bash
# 安装
raco pkg install racket-langserver
# 更新
raco pkg update racket-langserver
```

如果完全不想使用 lang-server，你也不必这样做，只要在扩展插件配置文件中设置 "magic-racket.lsp.enabled": false即可。但要注意，如果你这样做，你将无法获得 "智能 "功能，如自动完成、格式化等。

当然你也可以去 DrRacket 编辑器中的 Package Manager 中的 Do What I Mean 输入包名、文件、目录、URL、GitHub 链接来安装包依赖。

#### sicp 环境

Use DrRacket to install the sicp package like this:

  1. Open the Package Manager: in DrRacket choose the menu "File" then choose "Package Manager..." 
  2. In the tab "Do What I Mean" find the text field and enter: sicp
  3. Finally click the "Install" button
  4. Test it. Make sure DrRacket has "Determine language from source" in the bottom left corner. Write the following program and click run:

```
#lang sicp
(inc 42)
The expected output is 43.
```

Racket 本身提供了很好地对 SICP 支持，具体安装详情：https://docs.racket-lang.org/sicp-manual/Installation.html ；同样地，我们也可以使用命令行方式来安装 sicp 依赖包`raco pkg install sicp`。


#### 加载模块文件

很多情况下，我们需要将代码抽象提取成模块文件，这个时候就需要对模块进行导入导出了，这里简单说一下 sicp 如何导包：

lib.rkt
```racket
#lang racket
(define (sq x) (* x x))
(define (cube x) (* x x x))
(provide (all-defined-out))
```

test.rkt
```racket
#lang sicp
(#%require "lib.rkt")
(sq 5)
```

可以参考下面的两个网址：

- [Including an external file in racket](https://stackoverflow.com/questions/4809433/including-an-external-file-in-racket)
- [Setting up DrRacket for SICP](https://louischristopher.me/setting-up-drracket-for-sicp)

配置好这些之后，就可以在 VS Code 中愉快的练习 sicp 了，需要注意的是文件的扩展名需要写成 .rkt 哦，这样点击执行按钮的时候才能正常跑起来。

希望这篇文章能够对你有所帮助与收获，本文主观色彩比较浓、以初学者角度描述，有建议也欢迎提出噢。

### 参考

- [学习SICP（《计算机程序的构造和解释》）的一些准备工作](https://zhuanlan.zhihu.com/p/34313034)
- [DrRacket 的安装与 SICP 的配置](https://zhuanlan.zhihu.com/p/37056659)
- [程序设计技术和方法](https://www.math.pku.edu.cn/teachers/qiuzy/progtech/)
- [MIT Scheme 的基本使用](https://www.math.pku.edu.cn/teachers/qiuzy/progtech/scheme/mit_scheme.htm)
- [Scheme入门教程](https://deathking.github.io/yast-cn/)
- [Racket语言入门](https://tyrchen.github.io/racket-book/index.html)
- [SICP 解题集](https://sicp.readthedocs.io/en/latest/index.html)
- [Why I Still ‘Lisp’ (and You Should Too)](https://betterprogramming.pub/why-i-still-lisp-and-you-should-too-18a2ae36bd8)


