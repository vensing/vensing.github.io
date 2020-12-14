---
title: Hackintosh 尝鲜
comments: true
toc: true
date: 2020-12-08 20:14:10
categories:
  - 瞎折腾
tags:
  - 黑苹果
---

话说，最近苹果推出了基于 M1 芯片的 MacBook Air 和 MacBook Pro，以及新的 macOS Big Sur。本文将写写戴尔 G7 如何黑苹果尝鲜 ~~Big Sur~~ Catalina，如果您是忠实的 Windows 粉和 Linux 粉，在看的过程中感觉到任何不适的话，可以随时右上角关闭网页。至于各操作系统之间的圣战，我们就安安静静地吃瓜就好了。

<!--more-->

心血来潮突然折腾装黑苹果的契机，大概是因为前几天调试 iOS 浏览器网页时，在 Windows 下实在是无能为力? 然后就突发奇想地折腾安装黑苹果，反正这个世界上最好找的就是借口了。

说回黑苹果，其实早在一两年前看过一些黑苹果教程网页，但在看到无线网卡不能驱动无法上网、死机、卡屏以及其他各种问题时，把我这个小白给吓到劝退了。但谁又能阻挡住一颗脱缰的好奇心呢，说干就干。在拜读了「黑果小兵」博客的安装教程后，我就开始准备备份硬盘、格盘，做 U 盘安装镜像了。

<span style="color:red;"> Note: 本文仅供参考，因操作不当造成的后果概不负责。</span>

### 前期准备

- 电脑型号 DELL-G7-7588
- 操作系统 macOS Catalina 10.15.7
- 处理器 Intel Core i5-8300H @ 2.30GHz 四核
- 内存 16GB 2667 MHz DDR4
- 硬盘 HP SSD 1TGB PCIE NVME + HP SSD 500G SATA
- 显卡 Intel UHD Graphics 630 
- 网卡 Intel AC9560
- 声卡 ALC256 
- SMBIOS MacBookPro15,2 (13-inch, 2019

#### 准备安装盘

首先，我的机器是戴尔 G7 7588，戴尔的机器很多都可以黑苹果，人傻钱多戴的好处瞬间体现出来了。硬盘我有两块，一块是 m.2 接口 NVME 的 HP 1T SSD，另一块是 SATA 接口的 HP 500G SSD。至于为什么选惠普的盘，因为性价比高啊(虽然它好像是贴牌的)，800 多 1T 的 NVME SSD 已经挺实惠了，隔壁三星能卖到 1000+ (听说三星的盘对黑苹果不友好，但好像修复了)。我的想法是，Windows 就让它待在原来的 NVME SSD 上，500 G 的 SATA SSD 就用来装 macOS，这样总不至于把 Windows 搞崩吧？什么？都上黑苹果了还要 Windows 干啥？小孩子才做选择，大人还要打游戏呢。

由于我压根没考虑在一块硬盘上分出一个区来安装 macOS，所以本文就此略过。

#### 准备 U 盘安装镜像

在备份完 SATA SSD 之后，就可以把它格式化了，如果你安装盘的格式是 MBR，请将其改成 GPT 格式，MBR 在最近的 macOS 上并不被支持(后面抹盘的时候也会选择 GUID 分区)。接着从黑果小兵那下载了 macOS 10.15.7 Catalina 的 dmg 镜像，这个镜像包含 macOS、Clover EFI、OC EFI、WEPE EFI 全家桶，总之用它就对了。接下来呢，还得做一个 U 盘安装镜像，我用的是 balenaEtcher 这个工具。具体的操作步骤：

- 选择 dmg 镜像
- 选择要烧制的 U 盘
- 开始制作

当 balenaEtcher 出现绿色的 Complete 字样之后就说明烧制成功了，然后 Windows 会弹窗提示格式化 U 盘，无须理会它直接右上角关闭。

![准备 U 盘安装镜像](https://cdn.jsdelivr.net/gh/vensing/static@master/image/27CD5841-A62B-4CB1-8BAD-BBBE8D852301.png)

#### 准备机器机型 EFI

由于不同的机器硬件差别太大，所以必须要符合机型的 EFI 才能顺利的引导黑苹果，所以还需要去下载对应机型的 EFI。我选择的是最近比较流行的 OpenCore（OC）引导工具，那么去哪里找对应机型的 OC EFI 呢? 答案当然是万能的 Github 了，你也可以去「黑果小兵」博客查找符合你机器机型的 EFI 信息，最后基本都是要去 Github 下载的。

Dell G7 7588 的 EFI 有三个项目在维护，我使用的是 [FYQ-Hackintosh](https://github.com/flyfeng2002/FYQ-Hackintosh) 提供的 OC EFI。直接 Clone 仓库或者下载 zip 包，不要下载 Release 页面下的旧包。此仓库包含了 OC EFI 以及声卡修复脚本、雷电3补丁。使用分区工具删除 U 盘中 OC 分区里的文件，将下载的对应机器 OC EFI 复制到 U 盘 OC 分区下。 

#### BIOS设置

- UEFI Boot Path Security: Never
- SATA Operation: AHCI
- Enabled USB Boot Support: Enabled
- Enable External USB Port: Enabled
- Thunderbolt Security: No Security
- PTT Security: Disabled
- Secure Boot Enable: Disabled
- Intel SGX: Disabled
- VT for Direct I/O: Disabled
- Auto OS Recovery Threshold: Disabled
- SupportAssist OS Recovery: Disabled

### 安装 macOS

以下安装步骤参考自 [黑果小兵][1]，图片引用的是 Big Sur 的安装过程，但和 Catalina 的安装步骤基本一致。

开机，按 F12 选择 U盘 引导，光标移动到 EFI USB Device Parttion2 选择 OpenCore 分区启动：

![OpenCore 引导界面安装 Catalina](https://cdn.jsdelivr.net/gh/vensing/static@master/image/C0CF33FA-AC4D-4301-90EB-C214349420DA.png)

进入 OpenCore 主引导界面，选择 Install macOS Catalina，直接回车进入 OpenCore 引导。

出现安装界面，选择磁盘工具，点击继续：

![安装界面-磁盘工具](https://cdn.jsdelivr.net/gh/vensing/static@master/image/4F95D2BE-0D13-4ABE-8EE2-1DF1691D31B0.png)

进入磁盘工具，点击下图所示，选择显示所有设备：
![显示磁盘](https://cdn.jsdelivr.net/gh/vensing/static@master/image/DC50DF98-FF96-4452-ACC8-00783B6B0022.png)

选择 HP 500G SSD SATA 这块需要安装 macOS 的磁盘，点击抹掉，在弹出的窗口中输入：名称：Macintosh HD；格式：APFS；方案：GUID分区图。
![抹掉磁盘](https://cdn.jsdelivr.net/gh/vensing/static@master/image/889A7BAF-85B6-4E53-AE9C-315D361A0C9A.png)

点击抹除，然后等待操作结束，点击完成，通过菜单选择退出磁盘工具或者按窗口左上角红色按钮离开磁盘工具，返回到安装界面，选择安装 macOS，点击继续：
![安装 macOS](https://cdn.jsdelivr.net/gh/vensing/static@master/image/8DCEE97F-3AD4-4243-9E53-A1007772FB34.png)

然后点击同意安装协议，选择将要安装的磁盘卷标 Macintosh HD，点击继续：
![选择安装盘 Macintosh HD](https://cdn.jsdelivr.net/gh/vensing/static@master/image/3C17C17C-F285-4B07-81B9-EA48F5A4CCC3.png)

它会把USB安装盘上的安装文件预复制到要安装的系统分区里，这个过程通常会持续1-2分钟，之后系统会自动重启，进入第二阶段的安装：
![安装 macOS 中](https://cdn.jsdelivr.net/gh/vensing/static@master/image/1DB683B1-F640-40A4-8F26-A8D49F3E6C91.png)

重启后继续安装，在安装期间，通常会自动重启 2-3 遍。最好是把 OC EFI 启动项设置为第一项最先启动，否则重启时可能进入其他引导项，或者重启后手动选择 OC EFI。

之后就是进入设置向导界面了，后面的操作就不细说。

最后，来一张 macOS catalina 截图：

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/IMG_3658.png)



### 杂项


#### Hackintool 和 OCC

下载 Hackintool 和 OpenCore Configuration 软件

#### 挂载 EFI

安装完成之后，macOS 安装盘中还需要将 U 盘中 OC 分区的 EFI 复制到安装盘 EFI 分区中。先挂载安装盘 EFI，再将 U 盘 OC EFI 替换过去。

打开 OCC 软件，选择`工具`菜单项，点击`挂载 EFI`，选择 macOS 安装盘的 EFI 分区挂载:
![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-224137.jpg)
![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-224424.jpg)

也可以使用命令行挂载 EFI 分区：

```sh
# 列出所有磁盘分区
diskutil list
# 注意将 disk1s1 换成对应的 EFI 分区, 挂载需要 sudo 权限
sudo diskutil mount disk1s1
```


#### 休眠

在 Hackintool 电源项里点击刷新按钮左侧图标，将红色的项修改，之后变成绿色即可。休眠我这里是休眠即醒，貌似要设置 CFG 这些东西，嫌太复杂就直接设置桌面屏幕保护程序，开启后再进入系统需要解锁，感觉和休眠功能差不多。

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-224024.jpg)

#### 亮度调节

系统偏好设置里的默认亮度调节快捷键是 F14、F15，但我最多只有 F11、F12 是亮度调节，在系统设置快捷键里重新映射为 F11、F12 即可，亮度调节正常。
![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-225539.jpg)

#### 三码

`iMessages` 和 `FaceTime` 需要三码才能登录。

打开 OCC 软件，选择`工具`菜单项，点击`挂载 EFI`，选择 macOS 安装盘的 EFI 分区挂载，进入 EFI/OC 目录下，右键 config.plist 选择使用 OCC 打开：

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-224521.jpg)

进入 OCC 选择机型平台设置，切换到 DataHub-Generic-PlatformNVRAM， 查询序列号有效性右侧下拉框选择机型，最好是选择 CPU 型号接近的机型。此时 SSN、SUUID 码已经生成好，点击 ROM 项右侧`来自系统`，从 `Hack` 切换到 `Mac`，点击生成。

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-224749.jpg)

最好在 OCC 菜单栏上选择 `文件`-> `保持`，重启系统，三码生成就完成啦，可以在 Hackintool 系统菜单项中查看三码。对 Config.plist 修改之后要保存文件，建议对 EFI 分区进行备份。


#### 黑苹果开启原生HiDPI

一条命令可开启接近原生的 HIDPI 设置，脚本的 Github 项目地址: GitHub - xzhih/one-key-hidpi: Enable macOS HiDPI。

终端下执行:
```
Bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/xzhih/one-key-hidpi/master/hidpi.sh)"
```
如果访问Github出现网络超时的情况，可以使用下面国内的脚本命令：
```
Bash
sh -c "$(curl -fsSL https://html.sqlsec.com/hidpi.sh)"
```
开启后重启生效！

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-225812.jpg)

#### 无线

下载对应系统版本的 `AirportItlwm.kext` ：

Supported Intel WI-FI Cards By itlwm:

- 3xxx: 3160, 3165, 3168
- 7xxx: 7260, 7265
- 9xxx：9260,9461, 9462, 9560
- 22000：ax200

Supported Devices List
AirportItlwm.kext download from https://github.com/1hbb/OpenIntelWireless-Factory/releases, support OS:
- AirportItlwm-BigSur
- AirportItlwm-Catalina
- AirportItlwm-HighSierra
- AirportItlwm-Mojave

替换掉 `EFI/OC/Kexts` 中的 `AirportItlwm.kext`：

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-225336.jpg)

重启电脑，即可看到 wifi 功能已可以使用，接力功能可使用；隔空投送和随航等其它功能无法使用；实际测试下来网速和在 Windows 下的速度基本一致。

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/2020-12-06.5.57.56.png)

如果想要体验隔空投送和随航等功能，那么你可能需要更换博通网卡，但是已经被无良商家炒到两三百的价格...


#### 雷电3补丁

我的电脑是旧款 G7，将下载好的雷电3补丁目录打开，复制 `SSDT-THUNDERBOLT.aml` 到 `EFI/OC/ACPI` 目录下， 复制 `IOElectrify.kext` 到 `EFI/OC/Kexts` 目录下，用 OCC 打开 config.plist 文件，将复制好的 `SSDT-THUNDERBOLT.aml` 拖动到 `ACPI设置` 添加项中并启用；将复制好的 `IOElectrify.kext` 拖动到 `Kernel-内核` 设置添加项中并启用。重启电脑。

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-225020.jpg)
![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-225155.jpg)
![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-225934.jpg)

经测试，雷电3接口外接 Type-C 扩展坞可以连接 USB LAN 千兆以太网、USB-C PD 快充、HDMI 连接显示器正常输出视频、USB3.0 正常；支持设备热插拔。


![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/Jietu20201208-225850.jpg)

可以看到 wi-fi 功能已开启，并且雷电3外接 Type-C 扩展坞可以连接 USB LAN 千兆以太网，USB LAN 的网速测试和在机器自带 RJ45 网络速度基本一致。


### 问题

- 休眠功能可能无法使用
- 自带 HDMI 接口不能输出视频至外接显示器
- Intel 网卡驱动下的 2.4G WiFi 若有蓝牙设备(小米小爱音箱)连接，会严重干扰网速
- Intel WiFi 隔空投送和随航等功能无效(需更换博通网卡)
- 关机不断电(具体原因还在找，可能是刷了内核补丁引起的)

关于 1080P 下的 HiDPI ，如果设置成 1920\*1080 分辨率，字体和应用就会有点小和糊，启用更低分辨率的 HiDPI 之后，字体和应用 UI 变得硕大但是比较清晰，截图的分辨率会扩大一倍非常清晰。所以，我一般是 1920\*1080 这样能看到的东西更多，截图可以调低分辨率这样出来的图分辨率扩大一倍非常清晰。

从最近这些天的体验来说，macOS 已经能够胜任很多日常任务了，无论是浏览网页、看视频还是开发编程体验都比 Windows 要来得更好，且从未有过系统崩溃。如果你能忽略屏幕质量和黑苹果不完美下的各种小问题，且能有足够的时间去折腾，那么黑苹果体验可能会比 Windows 好很多。想要完美体验 macOS 还是得上 MacBook 和 4K 屏，更多关于 HiDPI 的内容请查看：[有关 retina 和 HiDPI 那点事](https://zhuanlan.zhihu.com/p/20684620)。

### OTA Big Sur

最近试了下从 Catalina 10.15.7 OTA 在线系统更新升级到 Big Sur 11.0.1，用移动固态硬盘和时间机器软件备份了一下 Catalina 系统，方便出问题回滚。

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/IMG_3736.JPG)

第一次下载完系统升级安装包之后安装时提示软件包缺失损坏，重启再下载就可以直接更新到 Big Sur。使用下来，基本没有任何问题，安装的软件也没有兼容性问题；Safari 14 终于可以加载 webp 格式的图片了。

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/IMG_3738.JPG)

换成圆角矩形应用图标风格后：

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/jietu2020-12-14.5.57.26.png)


### macOS 软件

![](https://cdn.jsdelivr.net/gh/vensing/static@master/image/2020-12-05.8.09.56.png)

- https://www.macwk.com
- https://lemon.qq.com/lab/


### 参考

[1]: https://mp.weixin.qq.com/s/9AfyueVyOX_SVHEUwihoaA

- [黑果小兵 - Big Sur 安装教程](https://mp.weixin.qq.com/s/9AfyueVyOX_SVHEUwihoaA)
- [Dell G7 7588 OC EFI](https://github.com/flyfeng2002/FYQ-Hackintosh)
- [OpenIntelWireless-Factory](https://github.com/1hbb/OpenIntelWireless-Factory)
- [有关 retina 和 HiDPI 那点事](https://zhuanlan.zhihu.com/p/20684620)



