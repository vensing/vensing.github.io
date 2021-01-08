---
title:  OpenCV Java 开发环境搭建
date: 2019-05-30 14:40:30
categories:
 - 瞎折腾
tags:
 - 开发环境
 - OpenCV
comments: true
toc: true
hidden: true
---



**OpenCV** 的全称是 Open Source Computer Vision Library ，是一个跨平台的计算机视觉库。OpenCV 是由英特尔公司发起并参与开发，以 BSD 许可证授权发行，可以在商业和研究领域中免费使用。
<!--more-->
OpenCV 可用于开发实时的图像处理、计算机视觉以及模式识别程序等，总之就是很厉害啦。



![OpenCV](https://cdn.jsdelivr.net/gh/vensing/static@master/image/225px-OpenCV_Logo_with_text.png)

### **OpenCV 开始折腾**

因为最近做的一些事情是有关于图像识别的（在 Java 开发环境下实现），说具体点就是识别图形的某些颜色的阈值区域。既然 OpenCV 这么厉害，还免费，而且跨平台，那么还有什么理由不选它呢。

一般这种图像识别的东西，都有开源的库，能白嫖就白嫖嘛，本着能做伸手党就不做动手党的原则，能不自己写就拿别人造的轮子（实际上也造不来轮子，况且 OpenCV 最开始的目标就是为了让后来者不重复造轮子）。



本文试图简单介绍下 OpenCV 的环境搭建，具体的使用场景我可能在后几篇博客文章中体现。

### **Windows 下 OpenCV 环境的搭建**

转到 [OpenCV 下载地址](https://opencv.org/releases/)，下载 Windows 下的 .exe 安装包。官方提供了Windows下的 Java 封装库，你只需点击安装即可，安装好之后会创建一个`opencv`文件夹，里面包含了开源协议、ReadMe、build 文件夹 (编译好的环境)、src (源代码)。

[按照官方的教程](https://docs.opencv.org/2.4.4-beta/doc/tutorials/introduction/desktop_java/java_dev_intro.html)，在 Eclipse 下的 Java 示例程序，首先是新建一个 Java 项目，名称随便就行。

选中项目右键 “_Project Properties_”，在对话框中打开“_Java Build Path_”选项卡，并新配置一个 User Library库（OpenCV）和它的引用（ jar 和 dll 库位置）：

![配置 jar 和 dll](https://cdn.jsdelivr.net/gh/vensing/static@master/image/eclipse_user_lib7.png)

jar 的位置是在 `opencv/build/java` 目录下，dll 在 `opencv/build/java/x64` 下(针对64位系统)，32位系统则是`opencv/build/java/x86` 下。

具体的操作步骤参考官网：[OpenCV Java 开发环境搭建教程](https://docs.opencv.org/2.4.4-beta/doc/tutorials/introduction/desktop_java/java_dev_intro.html) 。

当然，你也可以在项目中只引入 jar 包，再把 dll 放到 Java 安装目录下 jdkxx_xx 的 bin 目录中也是可以的。

**为什么要配置 dll 动态链接库呢？**

这是因为 OpenCV 用 C++ 语言编写，它的主要接口也是 C++ 语言，但是依然保留了大量的C语言接口。该库也有大量的Python、Java 、MATLAB 等的接口。所以呢，使用 Java 接口得添加一个 dll 动态链接库，而这个 dll 动态链接库是由 Windows 下 OpenCV 提供的 C/C++ 库编译转制过来的。同理，Linux 下是 `.so` lib库。

### **Linux 下 OpenCV 环境的搭建**

Windows 下的开发环境能白嫖，但是 Linux 和 Mac 下却要手动编译，只能说是非常的真实了(普通开发者用 windows 开发，大佬都是直接用 Linux 或者 Mac 开发)。

[按照官方教程](https://docs.opencv.org/3.4.1/d9/d52/tutorial_java_dev_intro.html)，为了编译这个库和示例程序，你需要准备很多库或者工具，其中包括：
*   JDK;（官方推荐是 JDK 6 或者 7，我用 8 也没问题）
*   GCC 编译器；
*   cmake 构建工具；
*   apache-ant 构建工具; （为了编译出 jar）

首先，去 [OpenCV 下载地址](https://opencv.org/releases/) 把源码下载下来，当然你也可以从 Github 上通过 Git 拉下来。

我下载的版本是 `opencv-3.4.1.zip` zip 包，上传到 `/usr/opencv` 目录下并且解压：

```sh
[root@localhost opencv]# unzip opencv-3.4.1.zip
```

新建一个`build`文件夹来存放编译后的文件：
```sh
[root@localhost opencv]# mkdir build
[root@localhost opencv]# cd build
```

进入`build`目录之后就可以开始编译了：
```sh
# Generate a Makefile
[root@localhost opencv]# cmake -DBUILD_SHARED_LIBS=OFF ..
# Now start the build
[root@localhost opencv]# make -j8
```

这个编译其实要挺久的，耐心等等就好了。看到如下图的`To be built:` 和 `java`就基本说明编译成功了。

![编译成功的标志](https://cdn.jsdelivr.net/gh/vensing/static@master/image/cmake_output.png)

编译后的 opencv-341.jar 位于 `opencv-3.4.1/build/bin`下，libopencv_java341.so 位于 `opencv-3.4.1/build/lib`下。

配置 opencv 环境：
```sh
# 加入下面的 opencv3.4.1
[root@localhost opencv]# vim /etc/profile

#opencv3.4.1#

OPENCV_HOME=/usr/opencv/opencv-3.4.1/build

OPENCV_BIN=/usr/opencv/opencv-3.4.1/build/bin

export PATH=$OPENCV_HOME/bin:$PATH

#设置.so的环境变量，没有会报 java.library.path 找不到lib的错误：no opencv_java341 in java.library.path。
export LD_LIBRARY_PATH=/usr/opencv/opencv-3.4.1/build/lib

#opencv3.4.1#

# 让配置文件生效
[root@localhost opencv]# source /etc/profile

```

**测试程序：**
新建一个`opencv_project`的目录，进入`opencv_project`新建一个`lib`目录：
```sh
[root@localhost test]# mkdir opencv_project
[root@localhost test]# cd opencv_project
[root@localhost opencv_project]# mkdir lib
```

将 `opencv-341.jar`拷贝到 lib 目录下，并新建一个SimpleSample.java 文件：
```sh
[root@localhost opencv_project]# vim SimpleSample.java
```

SimpleSample.java 内容如下:
```java
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.CvType;
import org.opencv.core.Scalar;

class SimpleSample {

  static{ System.loadLibrary(Core.NATIVE_LIBRARY_NAME); }

  public static void main(String[] args) {
    System.out.println("Welcome to OpenCV " + Core.VERSION);
    Mat m = new Mat(5, 10, CvType.CV_8UC1, new Scalar(0));
    System.out.println("OpenCV Mat: " + m);
    Mat mr1 = m.row(1);
    mr1.setTo(new Scalar(1));
    Mat mc5 = m.col(5);
    mc5.setTo(new Scalar(5));
    System.out.println("OpenCV Mat data:\n" + m.dump());
  }

}

```

编译 SimpleSample.java ，生成 class 字节码文件和执行程序：
```sh
[root@localhost opencv_project]# javac -cp ,:lib/opencv-341.jar SimpleSample.java 
[root@localhost opencv_project]# java -cp .:lib/opencv-341.jar SimpleSample

Welcome to OpenCV 3.4.1
OpenCV Mat: Mat [ 5*10*CV_8UC1, isCont=true, isSubmat=false, nativeObj=0x7f861c124550, dataAddr=0x7f861c1245c0 ]
OpenCV Mat data:
[  0,   0,   0,   0,   0,   5,   0,   0,   0,   0;
   1,   1,   1,   1,   1,   5,   1,   1,   1,   1;
   0,   0,   0,   0,   0,   5,   0,   0,   0,   0;
   0,   0,   0,   0,   0,   5,   0,   0,   0,   0;
   0,   0,   0,   0,   0,   5,   0,   0,   0,   0]

```

出现 `Welcome to OpenCV 3.4.1` 这样的字眼就说明环境配置和程序运行成功了。

你也可以[按照官方教程](https://docs.opencv.org/3.4.1/d9/d52/tutorial_java_dev_intro.html)验证环境、程序是否能正常运行，`opencv/samples/java/ant` 还有一个基于 ant 构建的Java 项目，按照官网教程在命令行中指定 jar 和 so 编译执行程序，也可以在 build.xml 指定 jar 和 so 。

此外在 `opencv/samples/java` 还有一个 SBT 的人脸识别示例程序。

感觉 Linux 下的 OpenCV 对我这种伸手党和白嫖党不是很友好 : ( 。嘛，瞎折腾就是了。